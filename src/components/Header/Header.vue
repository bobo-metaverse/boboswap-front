<template>
  <div id="Header">
    <img
      :src="theme == 'dark' ? logo : logo2"
      class="logo"
      @click="chageDrawer"
    />
    <div class="address">
      <img src="../../assets/images/addressIcon.png" />
      <span>0x2164j6…d010</span>
    </div>
  </div>
</template>
<script>
let logo = require("../../assets/images/logo.png");
let logo2 = require("../../assets/images/logo2.png");

export default {
  name: "Header",
  data() {
    return {
      logo: logo,
      logo2: logo2,
    };
  },
  computed: {
    theme() {
      return this.$store.state.skin;
    },
  },
  components: {},
  methods: {
    chageDrawer() {
      this.$emit("chageDrawer");
    },
  },
};
</script>
<style lang="scss">
@import "../../assets/styles/Header/header.scss";
</style>