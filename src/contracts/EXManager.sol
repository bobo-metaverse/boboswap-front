// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./BasicStruct.sol";
import "./Interfaces.sol";
import "./MixinAuthorizable.sol";

contract EXManager is MixinAuthorizable {
    using SafeMath for uint256;

    address public constant USDT = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
    address public constant USDC = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
    address public constant swapFactory = 0x5757371414417b8C6CAad45bAeF941aBc7d3Ab32;      // quickswap

    mapping(address => uint256) public usableTradePointsMap;  // 用户剩余可用的点卡金额，手续费可由此出
    
    uint256 public constant FACTOR = 1e8;
    uint256 public feePercent = 5;
    uint256 constant public BasePercent = 10000;
    uint256 public maxFreePointPerAccount = 10;
    uint256 public minDepositValue = 1e6;       // 充值点卡时的最小金额U
    uint256 public maxOrderNumberPerMatch = 5;    // 一次撮合最多可成交的订单数
    
    mapping(address => uint256) public tokenMinAmountMap;     // 一次交易最小金额
    mapping(address => address) public tokenAggregatorMap;    // token对应的chainlink聚合器合约地址
    mapping(address => bool) public routerWhiteList;          // router白名单
    mapping(address => uint256) public weightFactorMap;       // 每个交易对订单计算权重时的因子，用于调整各个交易对的重要性

    address public boboToken;
    uint256 public maxBoboTokenAmount = 1e23;  // 拥有不少于此数量的Bobo（默认10万），手续费打五折，拥有此数量十分之一的Bobo才开始打折（9折）
    
    mapping(uint256 => SpreadInfo) public spreadInfoMap;
    struct SpreadInfo {
        uint256 spreadCode;         // 推广码
        uint256 endBlock;           // 推广终止时间
        uint256 userRate;           // 用户充值提升比例
        uint256 commissionRate;     // 推广者佣金比例
        address spreaderAddr;       // 推广者地址
    }

    constructor (address _boboToken) public {
        usableTradePointsMap[msg.sender] = 10000;   // 给合约部署者提供1万U的手续费
        boboToken = _boboToken;
    }

    function setMaxBoboTokenAmount(uint256 _maxBoboTokenAmount) public onlyOwner {
        maxBoboTokenAmount = _maxBoboTokenAmount;
    }

    function setRouter(address _router, bool _bInWhiteList) public onlyOwner {
        routerWhiteList[_router] = _bInWhiteList;
    }

    function setWeightFactor(address _pairAddr, uint256 _weightFactor) public onlyOwner {
        weightFactorMap[_pairAddr] = _weightFactor;
    }

    // 根据Bobo持有数量获取折扣比例，最大50%，最小5%
    function getScalePercent(address _userAddr) view public returns(uint256) {
        uint256 boboAmount = ERC20(boboToken).balanceOf(_userAddr);
        if (boboAmount < maxBoboTokenAmount.div(10)) return 10000;

        if (boboAmount > maxBoboTokenAmount.div(10)) boboAmount = maxBoboTokenAmount;

        return 10000 - boboAmount.mul(5000).div(maxBoboTokenAmount);
    }
    
    function setTokenMinAmount(address _tokenAddr, uint256 _minAmount) public onlyOwner {
        tokenMinAmountMap[_tokenAddr] = _minAmount;
    }
    
    function setMaxOrderNumberPerMatch(uint256 _maxNumber) public onlyOwner {
        maxOrderNumberPerMatch = _maxNumber;
    }
    
    function setSpreadInfo(uint256 _spreadCode, uint256 _endBlock, uint256 _userRate, uint256 _commissionRate, address _spreaderAddr) public onlyOwner {
        require(_spreadCode > 0 && _endBlock > block.number, "EXManager: parameter ERROR");
        spreadInfoMap[_spreadCode] = SpreadInfo(_spreadCode, _endBlock, _userRate, _commissionRate, _spreaderAddr);
    }
    
    // 充值平台币，用U购买点数
    function buyTradePoints(uint256 _usdtAmount, uint256 _spreadCode) public {
        require(_usdtAmount >= minDepositValue, "EXManager: USDT amount must be bigger than minDepositValue.");
        ERC20(USDT).transferFrom(msg.sender, address(this), _usdtAmount);        
        SpreadInfo memory spreadInfo = spreadInfoMap[_spreadCode];
        if (spreadInfo.endBlock > block.number) {
            usableTradePointsMap[msg.sender] = usableTradePointsMap[msg.sender].add(_usdtAmount.add(_usdtAmount.mul(spreadInfo.userRate).div(100)));
            uint256 awardAmount = _usdtAmount.mul(spreadInfo.commissionRate).div(100);
            ERC20(USDT).transfer(spreadInfo.spreaderAddr, awardAmount);  
        } else {
            usableTradePointsMap[msg.sender] = usableTradePointsMap[msg.sender].add(_usdtAmount);
        }
    }

    // 转让点数
    function transferTradePoints(address _userAddr, uint256 _transferAmount) public {
        require(usableTradePointsMap[msg.sender] >= _transferAmount, "EXManager: your left trade points must be bigger than _transferAmount.");

        usableTradePointsMap[msg.sender] = usableTradePointsMap[msg.sender].sub(_transferAmount);
        usableTradePointsMap[_userAddr] = usableTradePointsMap[_userAddr].add(_transferAmount);
    }

    // 消耗点卡
    function deductTradeFee(address _userAddr, address _token, uint256 _amountIn) public onlyAuthorized returns(uint256) {        
        uint256 usdtDecimals = ERC20(USDT).decimals();
        uint256 tokenDecimals = ERC20(_token).decimals();
        uint256 tokenPrice = getTokenPrice(_token);  // *10^8
        
        uint256 scalePercent = getScalePercent(_userAddr);  // 根据用户当前持有的BOBO数量获取折扣比例
        uint256 tokenAmount4Fee = _amountIn.mul(feePercent).mul(scalePercent).div(BasePercent).div(BasePercent);
                                 
        uint256 usdtAmount4Fee = tokenPrice.mul(tokenAmount4Fee).mul(10**usdtDecimals).div(FACTOR).div(10**tokenDecimals);
        if (usableTradePointsMap[_userAddr] >= usdtAmount4Fee) {
            usableTradePointsMap[_userAddr] = usableTradePointsMap[_userAddr].sub(usdtAmount4Fee);
            return 0;
        } else {
            return tokenAmount4Fee;
        }      
    }

    // 评估手续费
    // 返回【需要扣除的token数量，token对应的usdt数量】,如果token数量返回为0，表示只需要扣除预存的usdt即可
    function evaluateDeductedAmountIn(address _userAddr, address _token, uint256 _amountIn) view public returns(uint256, uint256) {
        uint256 usdtDecimals = ERC20(USDT).decimals();
        uint256 tokenDecimals = ERC20(_token).decimals();
        uint256 tokenPrice = getTokenPrice(_token);  // *10^8
        
        uint256 scalePercent = getScalePercent(_userAddr);  // 根据用户当前持有的BOBO数量获取折扣比例
        uint256 tokenAmount4Fee = _amountIn.mul(feePercent).mul(scalePercent).div(BasePercent).div(BasePercent);  // 需要扣除的token数量

        uint256 usdtAmount4Fee = tokenPrice.mul(tokenAmount4Fee).mul(10**usdtDecimals).div(FACTOR).div(10**tokenDecimals);   // 需要扣除的usdt数量(即token的价值)
        if (usableTradePointsMap[_userAddr] >= usdtAmount4Fee) {
            return (0, usdtAmount4Fee);
        } else {
            return (tokenAmount4Fee, usdtAmount4Fee);
        }
    }

    function getTokenPrice(address _token) public view returns(uint256) {
        uint256 priceOnAMM = getTokenPriceOnAMM(_token);
        uint256 priceOnChainlink = getTokenPriceOnChainlink(_token);
        if(priceOnChainlink == 0) return priceOnAMM;

        uint256 gap = 0;
        if (priceOnAMM > priceOnChainlink) {
            gap = priceOnAMM.sub(priceOnChainlink).mul(1000).div(priceOnChainlink);
        } else {
            gap = priceOnChainlink.sub(priceOnAMM).mul(1000).div(priceOnAMM);
        }
        require(gap <= 100, "EXManager: the price gap between chainlink and AMM is large than 10%.");
        return priceOnChainlink;
    }

    function getTokenPriceOnAMM(address _token) public view returns(uint256) {
        if (_token == USDT || _token == USDC) return 1 * FACTOR;

        (address token0, address token1) = USDT < _token ? (USDT, _token) : (_token, USDT);
        address pairAddr = ICommonFactory(swapFactory).getPair(token0, token1);
        (uint256 reserveA, uint256 reserveB,) = ICommonPair(pairAddr).getReserves();
        uint256 decimalsGap = ERC20(_token).decimals() - ERC20(USDT).decimals();
        // 为匹配chainlink，此处的价格也乘上10^8（FACTOR）, 除以此FACTOR后的实际单位是U（如1.1U,1.12U）
        return token0 == USDT ? reserveA.mul(FACTOR).mul(10**decimalsGap).div(reserveB) : reserveB.mul(FACTOR).mul(10**decimalsGap).div(reserveA);
    }
    
    // chainlink返回的价格是U，但乘上了10^8
    function getTokenPriceOnChainlink(address _token) public view returns(uint256) {
        if (_token == USDT || _token == USDC) return 1 * FACTOR;

        address aggregatorAddr = tokenAggregatorMap[_token];
        if (aggregatorAddr == address(0)) return 0;

        AggregatorV3Interface priceFeed = AggregatorV3Interface(aggregatorAddr);
        (, int price,,,) = priceFeed.latestRoundData();
        return uint256(price);
    }

    function setFeePercent(uint256 _feePercent) public onlyOwner {
        feePercent = _feePercent;
    }
    
    function withdraw(address _token, address _receiver) public onlyOwner {
        uint256 amount = ERC20(_token).balanceOf(address(this));
        ERC20(_token).transfer(_receiver, amount);
    }
    
    function addAggregtor(address _token, address _aggregator) public onlyOwner {
        tokenAggregatorMap[_token] = _aggregator;
    }
}
