<template>
  <div class="pool">
    <div class="tvl">TVL = 10,000,000 U</div>
    <div class="pool_nav">
      <el-tabs v-model="activeName">
        <el-tab-pane label="流动性挖矿交易对" name="first">
          <TransactionCouple />
        </el-tab-pane>
        <el-tab-pane label="流动性挖矿单令牌" name="second">
          流动性挖矿单令牌</el-tab-pane
        >
      </el-tabs>
    </div>
  </div>
</template>
<script>
import TransactionCouple from "../components/Pool/TransactionCouple";
export default {
  name: "Pool",
  data() {
    return {
      activeName: "first",
    };
  },
  components: { TransactionCouple },
  methods: {},
};
</script>
<style lang="scss">
@import "../assets/styles/Pool/Pool";
</style>
