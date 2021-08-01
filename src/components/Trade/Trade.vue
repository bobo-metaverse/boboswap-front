<template>
  <div class="trade">
    <div class="trade_view">
      <div class="view_left">
        <!-- <img :src="theme == 'dark' ? view_img1 : view_img2" /> -->
        <span class="assets">{{pairInfo.symbol}}/{{pairInfo.baseTokenName}}</span>
        <span class="rate">{{ pairInfo.high24h > 0 ? "+" : null }}{{ pairInfo.high24h }}%</span>
      </div>
      <div class="view_right">
        <img src="../../assets/images/view_img2.png" @click="chart" />
        <i class="iconfont icon-more more"></i>
      </div>
    </div>
    <div class="trade_view2">
      <div class="view2_left">
        <div class="btns">
          <span :class="buy_sell ? 'buy' : null" @click="clickBuyBtn"
            >买入</span
          >
          <span :class="!buy_sell ? 'sell' : null" @click="clickSellBtn"
            >卖出</span
          >
        </div>
        <div class="input_i">
          <el-select
            v-model="delegateType"
            size="medium"
            popper-class="select_down"
            style="width: 100%; height: auto"
            placeholder="请选择委托类型"
          >
            <el-option
              v-for="item in options"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
            </el-option>
          </el-select>
        </div>
        <div v-if="delegateType == 'limitedDelegate'">
          <el-input-number
          size="medium"
          v-model="limitedPrice"
          :precision="2"
          :step="0.01"
          :max="100000"
          style="width: 100%"
        ></el-input-number>
        </div>
        <div v-else class="input_i">
          <!-- <el-input
            style="width: 216px; height: auto; background: #71819A;"
            :disabled="true"
          ></el-input> -->
        </div>
      </div>
      <div class="view2_right">
        <div class="title">
          <span>价格</span>
          <span>数量</span>
        </div>
        <div class="amount_item">
          <span class="span1">{{sellList[4].price}}</span>
          <span class="span2">{{sellList[4].amount}}</span>
          <div class="bg"></div>
        </div>
        <div class="amount_item">
          <span class="span1">{{sellList[3].price}}</span>
          <span class="span2">{{sellList[3].amount}}</span>
          <div class="bg" style="width: 30%"></div>
        </div>
        <div class="amount_item">
          <span class="span1">{{sellList[2].price}}</span>
          <span class="span2">{{sellList[2].amount}}</span>
          <div class="bg" style="width: 40%"></div>
        </div>
        <div class="amount_item">
          <span class="span1">{{sellList[1].price}}</span>
          <span class="span2">{{sellList[1].amount}}</span>
          <div class="bg" style="width: 50%"></div>
        </div>
        <div class="amount_item">
          <span class="span1">{{sellList[0].price}}</span>
          <span class="span2">{{sellList[0].amount}}</span>
          <div class="bg" style="width: 80%"></div>
        </div>
      </div>
    </div>
    <div class="view_cny"></div>
    <div class="shuliang">
      <span class="position">
        <el-input
          placeholder="数量"
          class="shuliang_input"
          style="font-size: 12px"
          v-model="inTokenAmount"
          @input="chageSlider"
        ></el-input>
        <span class="peer_token">{{inTokenSymbol}}</span>
      </span>
      <div class="shuliang_right">
        <span class="text_num">{{pairInfo.currentPrice}}</span>
      </div>
    </div>
    <div class="slide_box">
      <div class="slide_left">
        <el-slider
          class="slide_content"
          v-model="value2"
          :step="20"
          show-stops
          @change="chageInput"
          style="width: 100%"
        ></el-slider>
        <div class="edu">
          <span>可用额度</span>
          <span>
            {{ buy_sell ? (baseTokenAmount + ' ' + pairInfo.baseTokenName) : (quoteTokenAmount + ' ' + pairInfo.symbol) }}</span
          >
        </div>
        <!-- <div class="edu">
          <span>预计获得</span>
          <span>
            {{ buy_sell ? (pairInfo.quoteTokenAmount + ' ' + pairInfo.symbol) : (pairInfo.baseTokenAmount + ' ' + pairInfo.baseTokenName) }}</span
          >
        </div> -->
        <div class="edu">
          <span class="huadian"
            >滑点限制<i
              class="iconfont icon-sysseting"
              @click="centerDialogVisible = true"
            ></i
          ></span>
          <span>0.1 %</span>
        </div>
      </div>
      <div class="view2_right">
        <div class="amount_item">
          <span class="span1">{{buyList[4].price}}</span>
          <span class="span2">{{buyList[4].amount}}</span>
          <div class="bg"></div>
        </div>
        <div class="amount_item">
          <span class="span1">{{buyList[3].price}}</span>
          <span class="span2">{{buyList[3].amount}}</span>
          <div class="bg" style="width: 30%"></div>
        </div>
        <div class="amount_item">
          <span class="span1">{{buyList[2].price}}</span>
          <span class="span2">{{buyList[2].amount}}</span>
          <div class="bg" style="width: 40%"></div>
        </div>
        <div class="amount_item">
          <span class="span1">{{buyList[1].price}}</span>
          <span class="span2">{{buyList[1].amount}}</span>
          <div class="bg" style="width: 50%"></div>
        </div>
        <div class="amount_item">
          <span class="span1">{{buyList[0].price}}</span>
          <span class="span2">{{buyList[0].amount}}</span>
          <div class="bg" style="width: 80%"></div>
        </div>
      </div>
    </div>
    <div :class="buy_sell ? 'buy_peer_token' : 'sell_peer_token'">
      {{ buy_sell ? "买入" : "卖出" }} {{pairInfo.symbol}}
    </div>
    <!-- <div class="waring_tips">
      <img src="../../assets/images/waring_icon.png" />
      <span>本产品处于试运营阶段</span>
    </div> -->
    <div class="line_box"></div>
    <div class="list_box">
      <div class="list_nav">
        <span
          :class="listInde ? 'list_nav_active' : null"
          @click="listInde = !listInde"
          >当前委托</span
        ><span
          :class="!listInde ? 'list_nav_active' : null"
          @click="listInde = !listInde"
          >成交记录</span
        >
      </div>
      <CurrentEntrust v-if="listInde"/>
      <TransactionRecord v-else />
      <el-dialog
        title="交易设置"
        :visible.sync="centerDialogVisible"
        width="90%"
        center
      >
        <SlidingPointDialog />
      </el-dialog>
    </div>
  </div>
</template>

<script>
let view_img1 = require("../../assets/images/view_img1.png");
let view_img2 = require("../../assets/images/view_img3.png");
import CurrentEntrust from "./CurrentEntrust";
import TransactionRecord from "./TransactionRecord";
import SlidingPointDialog from "./SlidingPointSetingDialog";
import ERC20 from "../../assets/contracts/abi/ERC20.json";
import BoboPairABI from "../../assets/contracts/abi/BoboPair.json";
import BigNumber from "bignumber.js";

export default {
  name: "Trade",
  data() {
    return {
      buy_sell: true,
      listInde: true,
      view_img1: view_img1,
      view_img2: view_img2,
      inTokenAmount: "",
      limitedPrice: 1,
      value2: 0,
      centerDialogVisible: false,
      options: [
        {
          value: "marketDelegate",
          label: "市价委托",
        },
        {
          value: "limitedDelegate",
          label: "限价委托",
        },
      ],
      delegateType: 'limitedDelegate',
      pairInfo: {},
      pairIntervalId: 0,
      baseTokenAmount: 0,
      quoteTokenAmount: 0,
      inTokenSymbol: '',
      sellList: [{amount:0, price:0}, {amount:0, price:0}, {amount:0, price:0}, {amount:0, price:0}, {amount:0, price:0}],
      buyList: [{amount:0, price:0}, {amount:0, price:0}, {amount:0, price:0}, {amount:0, price:0}, {amount:0, price:0}],
    };
  },
  created:function() {
    this.pairInfo = JSON.parse(localStorage.getItem("CurPairInfo"));
    this.limitedPrice = this.pairInfo.currentPrice;
    this.inTokenSymbol = this.pairInfo.symbol;
    this.pairIntervalId = setInterval(() => {
      let pairInfos = this.$store.state.hangqing.filter(pairInfo => (pairInfo.symbol == this.pairInfo.symbol) && (pairInfo.baseTokenName == this.pairInfo.baseTokenName));
      this.pairInfo.high24h =  pairInfos[0].high24h;
    }, 3000);

    if (this.$store.state.drizzle.contracts[this.pairInfo.baseTokenName] == null) {
      var baseTokenContract = {
        contractName: this.pairInfo.baseTokenName,
        web3Contract: new this.$store.state.web3.eth.Contract(ERC20, this.pairInfo.baseTokenAddr)
      }
      this.$store.state.drizzle.addContract(baseTokenContract, []);
    }
    
    if (this.$store.state.drizzle.contracts[this.pairInfo.pairAddr] == null) {
      var pairContract = {
        contractName: this.pairInfo.pairAddr,
        web3Contract: new this.$store.state.web3.eth.Contract(BoboPairABI, this.pairInfo.pairAddr)
      }
      this.$store.state.drizzle.addContract(pairContract, []);
    }
    
    if (this.$store.state.drizzle.contracts[this.pairInfo.symbol] == null) {
      var quoteTokenContract = {
        contractName: this.pairInfo.symbol,
        web3Contract: new this.$store.state.web3.eth.Contract(ERC20, this.pairInfo.address)
      }
      this.$store.state.drizzle.addContract(quoteTokenContract, []);
    }
    this.updateTokenAmount();
    this.updateOrderList();
  },
  beforeDestroy() {
    clearInterval(this.pairIntervalId);
  },
  computed: {
    theme() {
      return this.$store.state.skin;
    },
  },
  components: { CurrentEntrust, TransactionRecord, SlidingPointDialog },
  methods: {
    chageInput(value) {
      //sliderChage
      this.input = value;
    },
    chageSlider(value) {
      //inputChange
      this.value2 = Number(value);
    },
    chart() {
      this.$store.dispatch("chageHeader", false);
      this.$router.push("/chart");
    },
    clickBuyBtn() {
      if (!this.buy_sell) {
        this.buy_sell = !this.buy_sell;
        this.updateInTokenSymbol(this.delegateType);
      }
    },
    clickSellBtn() {
      if (this.buy_sell) {
        this.buy_sell = !this.buy_sell;
        this.updateInTokenSymbol(this.delegateType);
      }
    },
    updateTokenAmount() {
      this.$store.state.drizzle.contracts[this.pairInfo.baseTokenName]
        .methods.balanceOf(this.$store.state.account)
        .call()
        .then(v => {
          this.baseTokenAmount = this.getReadableNumber(v, 6, 6);
      });

      this.$store.state.drizzle.contracts[this.pairInfo.symbol]
        .methods.balanceOf(this.$store.state.account)
        .call()
        .then(v => {
          this.quoteTokenAmount = this.getReadableNumber(v, this.pairInfo.decimals, 6);
      });
    },
    updateInTokenSymbol(value) {
      if (value == 'marketDelegate') {
        if (this.buy_sell) {
          this.inTokenSymbol = this.pairInfo.baseTokenName;
        } else {
          this.inTokenSymbol = this.pairInfo.symbol;
        }
      } else if (value == 'limitedDelegate') {
        if (this.buy_sell) {
          this.inTokenSymbol = this.pairInfo.symbol;
        } else {
          this.inTokenSymbol = this.pairInfo.symbol;
        }
      }
      this.inTokenAmount = 0;
    },
    updateOrderList() {
      var pairContract = this.$store.state.drizzle.contracts[this.pairInfo.pairAddr];
      pairContract.methods.getTotalOrderNumber(true).call().then(number => {
        pairContract.methods.getOrderInfos(true, 0, number > 5 ? 5 : number).call().then(orderInfos => {
          console.log('buyOrder', orderInfos);
          const length = orderInfos.orderIds.length;
          var i = 0;
          while(i < 5) {
            this.buyList[i].amount = this.getReadableNumber(orderInfos.amounts[i], 18, 2);
            this.buyList[i].price = this.getReadableNumber(orderInfos.orderPrices[i], 6, 2);
            i++;
          }
        });
      });
      pairContract.methods.getTotalOrderNumber(false).call().then(number => {
        pairContract.methods.getOrderInfos(false, 0, number > 5 ? 5 : number).call().then(orderInfos => {
          console.log('sellOrder', orderInfos);
          const length = orderInfos.orderIds.length;
          var i = 0;
          while(i < 5) {
            this.sellList[i].amount = this.getReadableNumber(orderInfos.amounts[i], 18, 2);
            this.sellList[i].price = this.getReadableNumber(orderInfos.orderPrices[i], 6, 2);
            i++;
          }
        });
      });
    },
    getReadableNumber(value, assetDecimal, displayDecimal) {
      let renderValue = new BigNumber(value);
      renderValue = renderValue.shiftedBy(assetDecimal * -1);

      let decimalPlaces = assetDecimal > 6 ? 6 : assetDecimal;
      if (renderValue.comparedTo(new BigNumber(0.000001)) < 0) {
        decimalPlaces = assetDecimal;
      }

      BigNumber.config({ DECIMAL_PLACES: displayDecimal == null ? decimalPlaces : displayDecimal });
      renderValue = renderValue.toString(10);
      return renderValue;
    },
    checkBalanceEnough() {
      if (this.buy_sell) {
        if (this.delegateType == 'marketDelegate') {   // 市价买单输入的就是U的数量
          if (this.inTokenAmount - this.baseTokenAmount > 0)
            return false;
        } else {  // 限价买单输入的是quoteToken的数量，所以需要乘上购买的价格，可以得出所需要的U的数量
          if (this.limitedPrice * this.inTokenAmount > this.baseTokenAmount)
            return false;
        }
      } else {
        if (this.delegateType == 'marketDelegate') {   // 市价卖单输入的quoteToken的数量
          if (this.inTokenAmount - this.quoteTokenAmount > 0)
            return false;
        } else {  // 限价卖单输入的是quoteToken的数量，所以需要乘上出售的价格，可以得出所需要的U的数量
          if (this.limitedPrice * this.inTokenAmount > this.quoteTokenAmount)
            return false;
        }
      }
      return true;
    }
  },
  watch: {
    "delegateType": function (value) {
      this.updateInTokenSymbol(value);
    },
    "limitedPrice": function (value) {
      
    },
    "inTokenAmount": function (value) {
      if (!this.checkBalanceEnough()) {
        this.toast("error", "您的余额不足");
      }
    }
  }
};
</script>
<style  lang="scss">
@import "../../assets/styles/Trade/Trade";
</style>
