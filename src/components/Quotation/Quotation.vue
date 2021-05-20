<template>
  <div class="quotation">
    <div class="quotation_nav">
      <div class="nav_left">
        <span>自选</span>
        <span
          v-for="(item, index) in TypeList"
          :key="index"
          :class="activeIndex == index ? 'active' : null"
          @click="chageActiveIndex(index)"
          >{{ item.id }}</span
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
    <div
      class="list"
      v-for="(list, listIndex) in TypeList"
      :key="listIndex"
      v-show="listIndex == activeIndex"
    >
      <div class="list_item" v-for="(item, index) in list.data" :key="index">
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
const aa = [];
export default {
  name: "Quotation",
  data() {
    return {
      TypeList: [],
      activeIndex: 0, //1:自选，2：HT,3:USDT
    };
  },
  computed: {
    chainId() {
      return this.$store.state.chainId;
    },
  },
  async created() {
    //console.log(this.chainId);
    //console.log(this.$store.state.hangqing);
    let data = this.$store.state.hangqing;
    let map = {};
    if (data.length > 0) {
      for (let i = 0; i < data.length; i++) {
        let ai = data[i];
        if (!map[ai.baseTokenName]) {
          map[ai.baseTokenName] = [ai];
        } else {
          map[ai.baseTokenName].push(ai);
        }
      }
      let res = [];
      Object.keys(map).forEach((key) => {
        res.push({
          id: key,
          data: map[key],
        });
      });
      this.TypeList = res;
    }
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