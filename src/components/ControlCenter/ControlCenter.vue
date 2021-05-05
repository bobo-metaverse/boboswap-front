<template>
  <div class="center" :data-theme="theme">
    <img
      :src="theme == 'dark' ? logo : logo2"
      class="logo"
      @click="chageSkin"
    />
    <div class="welcome" v-if="!linkStatus">
      <div class="link">
        <span @click="linkStatus = true">点击连接钱包</span>
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
      <div class="control_item">
        <img :src="theme == 'dark' ? img5 : img5_5" />
        <span>简体中文/ USD / light</span>
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
    };
  },
  watch: {
    theme(newThem) {
      localStorage.setItem("Skin", newThem);
      this.$store.dispatch("changeSkin", newThem);
    },
  },
  methods: {
    chageSkin() {
      this.theme = localStorage.getItem("Skin") == "dark" ? "light" : "dark";
      localStorage.setItem("Skin", this.theme);
    },
  },
};
</script>
<style lang="scss">
@import "../../assets/styles/ControlCenter/ControlCenter.scss";
</style>