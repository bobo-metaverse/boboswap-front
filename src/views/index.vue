<template>
  <div class="index" :data-theme="theme">
    <Header />
    <router-view></router-view>
    <!-- <MainNet /> -->
  </div>
</template>
<script>
import Header from "../components/Header/Header";
// import Header from "../components/Header/Header";
// import MainNet from "../components/Footer/SelectMainNet";
export default {
  name: "Index",
  data() {
    return {
      lang: localStorage.getItem("Lang") ? localStorage.getItem("Lang") : "zh",
      theme: localStorage.getItem("Skin")
        ? localStorage.getItem("Skin")
        : "light",
      rate: localStorage.getItem("Rate") ? localStorage.getItem("Rate") : "USD",
    };
  },
  mounted() {
    localStorage.getItem("Lang") ? null : localStorage.setItem("Lang", "zh");
    localStorage.getItem("Skin") ? null : localStorage.setItem("Skin", "dark");
    localStorage.getItem("Rate") ? null : localStorage.setItem("Rate", "USD");
  },
  watch: {
    theme(newThem) {
      localStorage.setItem("Skin", newThem);
    },
    rate(newRate) {
      localStorage.setItem("USD", newRate);
    },
  },
  methods: {
    switchSkin(them) {
      //换肤
      //this.theme = this.theme == "linght" ? "dark" : "linght";
      this.theme = them;
    },
    changeLaguages() {
      //语言切换
      let lang = this.$i18n.locale;
      if (lang == "zh") {
        localStorage.setItem("Lang", "en");
        this.$i18n.locale = localStorage.getItem("Lang");
      } else if (lang == "en") {
        localStorage.setItem("Lang", "zh");
        this.$i18n.locale = localStorage.getItem("Lang");
      }
    },
    refresh() {
      //重载
      location.reload();
    },
  },
  components: { Header },
};
</script>
<style lang="scss" >
@import "../assets/styles/base";
.index {
  width: 100%;
  height: auto;
  min-height: 100%;
  @include bg-color(bg);
  font-size: 14px;
}
</style>