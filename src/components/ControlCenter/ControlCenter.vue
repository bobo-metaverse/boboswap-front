<template>
  <div class="center" :data-theme="theme">
    <img :src="theme == 'dark' ? logo : logo2" class="logo" />
    <div class="welcome" v-if="!linkStatus">
      <div class="link">
        <span @click="connectPackage">点击连接钱包</span>
        <i class="iconfont icon-right"></i>
      </div>
      <div class="welcomen_text">欢迎来到BoBoswap</div>
    </div>
    <div class="user_center" v-else>
      <img src="../../assets/images/user_center_img.png" />
      <span class="address">0x2164j6…d010</span>
      <span class="total_asset">账户总资产折合(USDT)</span>
      <span class="total_num">0.00000000</span>
      <span class="total_asset">≈0.00(RMB)</span>
    </div>
    <div class="control">
      <div class="control_item">
        <img :src="theme == 'dark' ? img1 : img1_1" />
        <span>流动性挖矿</span>
      </div>
      <div class="control_item">
        <img :src="theme == 'dark' ? img2 : img2_2" />
        <span>DAO</span>
      </div>
      <div class="control_item">
        <img :src="theme == 'dark' ? img3 : img3_3" />
        <span>交易挖矿</span>
      </div>
      <div class="control_item">
        <img :src="theme == 'dark' ? img4 : img4_4" />
        <span>跨链桥</span>
      </div>
      <div class="control_item seting">
        <img :src="theme == 'dark' ? img5 : img5_5" />
        <span @click="showAction = !showAction">
          {{ lang == 1 ? "简体中文" : "English" }}
          / {{ rate == 1 ? "CNY" : "USDT" }} /
          {{ skin == 1 ? "Dark" : "Light" }}
        </span>
        <i
          class="iconfont icon"
          :class="showAction ? 'icon-up1' : ' icon-down_3'"
        ></i>
        <div class="seting_box" v-show="showAction">
          <div class="item">
            <span class="title">语言</span>
            <div class="lang" @click="chageLang(1)">
              <span>简体中文</span>
              <i
                v-show="lang == 1"
                class="iconfont icon-chose"
                :class="lang == 1 ? 'actived' : null"
              ></i>
            </div>
            <div class="lang right" @click="chageLang(2)">
              <span>English</span>
              <i
                v-show="lang == 2"
                class="iconfont icon-chose"
                :class="lang == 2 ? 'actived' : null"
              ></i>
            </div>
          </div>

          <div class="item">
            <span class="title">汇率</span>
            <div class="lang" @click="chageRate(1)">
              <span>CNY</span>
              <i
                v-show="rate == 1"
                class="iconfont icon-chose"
                :class="rate == 1 ? 'actived' : null"
              ></i>
            </div>
            <div class="lang right" @click="chageRate(2)">
              <span>USDT</span>
              <i
                v-show="rate == 2"
                class="iconfont icon-chose"
                :class="rate == 2 ? 'actived' : null"
              ></i>
            </div>
          </div>

          <div class="item">
            <span class="title">主题</span>
            <div class="lang" @click="chageSkin(1)">
              <span>Dark</span>
              <i
                v-show="skin == 1"
                class="iconfont icon-chose"
                :class="skin == 1 ? 'actived' : null"
              ></i>
            </div>
            <div class="lang right" @click="chageSkin(2)">
              <span>Light</span>
              <i
                v-show="skin == 2"
                class="iconfont icon-chose"
                :class="skin == 2 ? 'actived' : null"
              ></i>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
let logo = require("../../assets/images/logo.png");
let logo2 = require("../../assets/images/logo2.png");
let img1 = require("../../assets/images/control_img1.png");
let img1_1 = require("../../assets/images/control_img1_1.png");
let img2 = require("../../assets/images/control_img2.png");
let img2_2 = require("../../assets/images/control_img2_2.png");
let img3 = require("../../assets/images/control_img3.png");
let img3_3 = require("../../assets/images/control_img3_3.png");
let img4 = require("../../assets/images/control_img4.png");
let img4_4 = require("../../assets/images/control_img4_4.png");
let img5 = require("../../assets/images/control_img5.png");
let img5_5 = require("../../assets/images/control_img5_5.png");
export default {
  name: "ControlCenter",
  data() {
    return {
      logo: logo,
      logo2: logo2,
      linkStatus: false,
      img1,
      img1_1,
      img2,
      img2_2,
      img3,
      img3_3,
      img4,
      img4_4,
      img5,
      img5_5,
      theme: localStorage.getItem("Skin"),
      lang: localStorage.getItem("Lang") == "zh" ? 1 : 2,
      rate: localStorage.getItem("Rate") == "USDT" ? 1 : 2,
      skin: localStorage.getItem("Skin") == "dark" ? 1 : 2,
      showAction: false,
      chainId: null,
      web3: null,
    };
  },
  watch: {
    theme(newThem) {
      localStorage.setItem("Skin", newThem);
      this.$store.dispatch("changeSkin", newThem);
    },
  },
  methods: {
    chageLang(n) {
      this.lang = n;
    },
    chageRate(n) {
      this.rate = n;
    },
    chageSkin(n) {
      this.skin = n;
      this.theme = localStorage.getItem("Skin") == "dark" ? "light" : "dark";
      localStorage.setItem("Skin", this.theme);
    },
    async connectPackage() {
      const _this = this;
      //链接钱包
      if (!window.ethereum && !window.web3) {
        //用来判断你是否安装了metamask
        //Feedback.toast.error('请安装MetaMask');
        console.log("请安装MetaMask");
      } else {
        if (window.ethereum) {
          try {
            // 请求用户授权
            await window.ethereum.enable();
            if (
              window.ethereum.networkVersion != "56" &&
              window.ethereum.networkVersion != "128"
            ) {
              //Feedback.toast.error("请将MetaMask连接到BSC或Heco网络，否则您无法正常使用本网站");
              console.log(
                "请将MetaMask连接到BSC或Heco网络，否则您无法正常使用本网站"
              );
            } else {
              _this.chainId = window.ethereum.networkVersion; // 链ID，bsc=56, heco=128
              _this.web3 = new Web3(window.ethereum); // window.ethereum是MetaMask嵌入到浏览器的对象
              _this.web3.eth.getAccounts().then((accounts) => {
                // 获取MetaMask上的当前账号地址accounts[0]]
                const account =
                  accounts[0].substr(0, 6) +
                  "..." +
                  accounts[0].substr(accounts[0].length - 3);
              });
              // MetaMask地址变化时，要刷新网站
              ethereum.on("chainChanged", (chainId) => {
                history.go(0);
              });
            }
          } catch (error) {
            // 用户不授权时
            //Feedback.toast.error("MetaMask授权失败，会导致您无法正常使用本网站");
            console.log("MetaMask授权失败，会导致您无法正常使用本网站");
            return;
          }
        }
      }
    },
  },
};
</script>
<style lang="scss">
@import "../../assets/styles/ControlCenter/ControlCenter.scss";
</style>