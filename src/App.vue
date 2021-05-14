<template>
  <div id="app">
    <router-view />
  </div>
</template>
<script>
import Web3 from "web3";
import { myMixins } from "./assets/js/Wallet/ConnectWallet";
export default {
  data() {
    return {
      web3: null,
    };
  },
  mixins: [myMixins],
  created() {
    this.connectWallet();
  },
  methods: {},
  components: {},
};
</script>


<style lang="scss">
@import "./assets/styles/base.scss";
#app {
  font-family: "Playfair Display SC";
}
</style>
