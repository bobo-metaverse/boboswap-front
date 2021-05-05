<template>
  <div class="index" :data-theme="theme">
    <Header v-show="isHeader" />
    <router-view></router-view>
  </div>
</template>
<script>
import Header from "../components/Header/Header";
export default {
  name: "Index",
  data() {
    return {
      lang: localStorage.getItem("Lang") ? localStorage.getItem("Lang") : "zh",
      // theme: localStorage.getItem("Skin")
      //   ? localStorage.getItem("Skin")
      //   : "light",

      rate: localStorage.getItem("Rate") ? localStorage.getItem("Rate") : "USD",
    };
  },
  mounted() {
    localStorage.getItem("Lang") ? null : localStorage.setItem("Lang", "zh");
    localStorage.getItem("Skin") ? null : localStorage.setItem("Skin", "dark");
    localStorage.getItem("Rate") ? null : localStorage.setItem("Rate", "USD");
  },
  computed: {
    theme() {
      return this.$store.state.skin;
    },
    isHeader() {
      return this.$store.state.header;
    },
  },
  watch: {
    isHeader(newHeader) {
      this.$store.dispatch("chageHeader", newHeader);
    },
    theme(newThem) {
      localStorage.setItem("Skin", newThem);
      this.$store.dispatch("changeSkin", newThem);
    },
    rate(newRate) {
      localStorage.setItem("USD", newRate);
    },
  },
  methods: {
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
  height: 100%;
  overflow-y: scroll;

  font-size: 14px;
}
</style>