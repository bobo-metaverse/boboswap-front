<template>
  <div class="ChartChild">
    <div class="nav">
      <!-- <span class="nav_text nav_active">分时</span> -->
      <span class="nav_text nav_active">15分</span>
      <span class="nav_text">1小时</span>
      <span class="nav_text">4小时</span>
      <span class="nav_text">日线</span>
      <span class="nav_text addicon"
        ><span>更多</span><i class="iconfont icon-more1"></i
      ></span>
    </div>
    <div class="line"></div>
    <div class="line"></div>
  </div>
</template>
<script>
export default {
  name: "ChartChild",
  data() {
    return {};
  },
  methods: {},
};
</script>
<style lang="scss" scoped>
@import "../../assets/styles/Chart/ChartChild";
</style>