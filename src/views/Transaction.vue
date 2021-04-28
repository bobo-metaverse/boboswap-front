<template>
  <div class="transaction">
    <div class="transaction_nav">
      <span class="active">交易</span><span>矿池</span>
    </div>
    <Trade />
  </div>
</template>
<script>
import Trade from "../components/Trade/Trade";
export default {
  name: "Transaction",
  components: { Trade },
  data() {
    return {};
  },
  methods: {},
};
</script>
<style lang="scss">
@import "../assets/styles/Trade/Transaction";
</style>