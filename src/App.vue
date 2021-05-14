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
    // console.log(this.$store.state.account);
    // const _this = this;
    // if (!window.ethereum && !window.web3) {
    //   //用来判断你是否安装了metamask
    //   _this.toast("error", "请安装MetaMask");
    // } else {
    //   //链接钱包
    //  if (!window.ethereum && !window.web3) {
    //     //用来判断你是否安装了metamask
    //     _this.toast("error", "请安装MetaMask");
    //   } else {
    //     if (window.ethereum) {
    //       try {
    //         // 请求用户授权
    //         await window.ethereum.enable();
    //         if (
    //           window.ethereum.networkVersion != "56" &&
    //           window.ethereum.networkVersion != "128"
    //         ) {
    //           _this.toast(
    //             "error",
    //             "请将MetaMask连接到BSC或Heco网络，否则您无法正常使用本网站"
    //           );
    //         } else {
    //           //_this.isConnected = true;
    //           const chainId = window.ethereum.networkVersion; // 链ID，bsc=56, heco=128
    //           _this.web3 = new Web3(window.ethereum); // window.ethereum是MetaMask嵌入到浏览器的对象
    //           //console.log(_this.web3);
    //           _this.web3.eth.getAccounts().then((accounts) => {
    //             // 获取MetaMask上的当前账号地址accounts[0]]
    //             const account =
    //               accounts[0].substr(0, 6) +
    //               "..." +
    //               accounts[0].substr(accounts[0].length - 3);
    //             _this.$store.dispatch("setAccount", account);
    //             _this.$store.dispatch("setIsConnected", true);
    //             console.log(account);
    //           });
    //           // MetaMask地址变化时，要刷新网站
    //           ethereum.on("chainChanged", (chainId) => {
    //             // history.go(0);
    //             console.log(chainId);
    //             window.location.reload();
    //           });
    //         }
    //       } catch (error) {
    //         // 用户不授权时
    //         _this.toast(
    //           "error",
    //           "MetaMask授权失败，会导致您无法正常使用本网站"
    //         );
    //         return;
    //       }
    //     }
    //   }
    // }
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
