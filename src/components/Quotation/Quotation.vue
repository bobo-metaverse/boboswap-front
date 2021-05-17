<template>
  <div class="quotation">
    <div class="quotation_nav">
      <div class="nav_left">
        <span
          :class="activeIndex == 1 ? 'active' : null"
          @click="chageActiveIndex(1)"
          >自选</span
        >
        <span
          :class="activeIndex == 2 ? 'active' : null"
          @click="chageActiveIndex(2)"
          >HT</span
        >
        <span
          :class="activeIndex == 3 ? 'active' : null"
          @click="chageActiveIndex(3)"
          >USDT</span
        >
      </div>
      <img src="../../assets/images/search.png" @click="goSearch" />
    </div>

    <div class="filter">
      <div class="filter_left">
        <div class="left_box">
          <span class="text">名称</span>
          <span class="filter_imgs">
            <i class="iconfont icon-up"></i>
            <i class="iconfont icon-down"></i>
          </span>
        </div>
        <div class="left_box">
          <span class="text">24H额</span>
          <span class="filter_imgs">
            <i class="iconfont icon-up"></i>
            <i class="iconfont icon-down"></i>
          </span>
        </div>
      </div>

      <div class="filter_left">
        <div class="left_box">
          <span class="text">最新价</span>
          <span class="filter_imgs">
            <i class="iconfont icon-up"></i>
            <i class="iconfont icon-down"></i>
          </span>
        </div>
        <div class="left_box" style="margin-right: 0">
          <span class="text">涨跌幅</span>
          <span class="filter_imgs">
            <i class="iconfont icon-up"></i>
            <i class="iconfont icon-down"></i>
          </span>
        </div>
      </div>
    </div>
    <!-- list_data -->
    <div class="list">
      <div
        class="list_item"
        v-for="(item, index) in transactionPair"
        :key="index"
      >
        <div class="item_left">
          <div class="text1">
            <span>{{ item.symbol }}</span
            ><span>/ {{ item.baseTokenName }}</span>
          </div>
          <div class="text2">24H额￥***万</div>
        </div>
        <div class="item_right">
          <div class="right_div1"><span>--</span><span>￥**</span></div>
          <span class="right_div2" :class="item.high24h > 0 ? 'up' : 'down'"
            >{{ item.high24h > 0 ? "+" : null }}{{ item.high24h }}%</span
          >
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: "Quotation",
  data() {
    return {
      activeIndex: 2, //1:自选，2：HT,3:USDT
      list: [],
      transactionPair: [],
    };
  },
  computed: {
    chainId() {
      return this.$store.state.chainId;
    },
  },
  created() {
    console.log(this.chainId);
    this.getQuotation();
  },
  methods: {
    chageActiveIndex(index) {
      this.activeIndex = index;
    },
    goSearch() {
      this.$store.dispatch("chageHeader", false);
      this.$router.push("/search");
    },
    filerArry(arr1, arr2) {
      let newArr = [];
      for (let i = 0; i < arr2.length; i++) {
        for (let j = 0; j < arr1.length; j++) {
          if (arr1[j] === arr2[i].address) {
            newArr.push(arr2[i]);
          }
        }
      }
      return newArr;
    },

    getQuotation() {
      const _this = this;
      this.$axios.get(this.$API.getQuotation).then((quotation) => {
        //console.log(quotation);
        let chainId = _this.chainId.toString();
        _this.list = quotation.data[chainId];

        _this.list.pairs.map((item1) => {
          const list = _this.filerArry(item1.peerTokens, _this.list.assets);
          list.map((item) => {
            item.baseTokenAddr = item1.baseTokenAddr;
            item.baseTokenName = item1.baseTokenName;
            item.coingecko_currency = item1.coingecko_currency;
            //
            //24H涨跌幅
            let url =
              _this.$API.getRiseFall +
              "vs_currency=" +
              item.coingecko_currency +
              "&ids=" +
              item.coingeckoId;
            _this.$axios.get(url).then((res) => {
              // console.log(res.data[0].high_24h);
              item.high24h = res.data[0].price_change_percentage_24h.toFixed(2);
              _this.transactionPair.push(item);
            });
          });
        });
        console.log(_this.transactionPair);
      });
    },
  },
};
</script>
<style lang="scss">
@import "../../assets/styles/Quotation/Quotation.scss";
</style>