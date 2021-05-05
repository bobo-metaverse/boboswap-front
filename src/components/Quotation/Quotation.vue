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
      <div class="list_item">
        <div class="item_left">
          <div class="text1"><span>FILDA</span><span>/ USDT</span></div>
          <div class="text2">24H额￥471.14万</div>
        </div>
        <div class="item_right">
          <div class="right_div1">
            <span>18.1284</span><span>￥4120.72</span>
          </div>
          <span class="right_div2 up">+1.23%</span>
        </div>
      </div>

      <div class="list_item">
        <div class="item_left">
          <div class="text1"><span>BTC</span><span>/ USDT</span></div>
          <div class="text2">24H额￥4594.28万</div>
        </div>
        <div class="item_right">
          <div class="right_div1"><span>0.8834</span><span>￥ 5.88</span></div>
          <span class="right_div2 down">-2.12%</span>
        </div>
      </div>

      <div class="list_item">
        <div class="item_left">
          <div class="text1"><span>ETH</span><span>/ USDT</span></div>
          <div class="text2">24H额￥2935.66万</div>
        </div>
        <div class="item_right">
          <div class="right_div1"><span>0.7682</span><span>￥5.12</span></div>
          <span class="right_div2 up">+4.12%</span>
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
      activeIndex: 1, //1:自选，2：HT,3:USDT
    };
  },
  methods: {
    chageActiveIndex(index) {
      this.activeIndex = index;
    },
    goSearch() {
      this.$store.dispatch("chageHeader", false);
      this.$router.push("/search");
    },
  },
};
</script>
<style lang="scss">
@import "../../assets/styles/Quotation/Quotation.scss";
</style>