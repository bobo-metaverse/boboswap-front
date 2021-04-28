<template>
  <div class="trade">
    <div class="trade_view">
      <div class="view_left">
        <img src="../../assets/images/view_img1.png" />
        <span class="assets">FILDA/USDT</span>
        <span class="rate">-38.37%</span>
      </div>
      <div class="view_right">
        <img src="../../assets/images/view_img2.png" />
        <i class="iconfont icon-more more"></i>
      </div>
    </div>
    <div class="trade_view2">
      <div class="view2_left">
        <div class="btns">
          <span class="buy">买入</span>
          <span class="">卖出</span>
        </div>
        <div class="input_i">
          <el-select
            v-model="value"
            size="medium"
            popper-class="select_down"
            style="width: 100%"
            placeholder="现价委托"
          >
            <el-option
              v-for="item in options"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
            </el-option>
          </el-select>
        </div>
        <el-input-number
          size="medium"
          v-model="num"
          :precision="2"
          :step="0.1"
          :max="10"
          style="width: 100%"
        ></el-input-number>
      </div>
      <div class="view2_right">
        <div class="title">
          <span>数量</span>
          <span>数量</span>
        </div>
        <div class="amount_item">
          <span class="span1">0.7756</span>
          <span class="span2">29.99</span>
          <div class="bg"></div>
        </div>
        <div class="amount_item">
          <span class="span1">0.7756</span>
          <span class="span2">29.99</span>
          <div class="bg" style="width: 30%"></div>
        </div>
        <div class="amount_item">
          <span class="span1">0.7756</span>
          <span class="span2">29.99</span>
          <div class="bg" style="width: 40%"></div>
        </div>
        <div class="amount_item">
          <span class="span1">0.7756</span>
          <span class="span2">29.99</span>
          <div class="bg" style="width: 50%"></div>
        </div>
        <div class="amount_item">
          <span class="span1">0.7756</span>
          <span class="span2">29.99</span>
          <div class="bg" style="width: 80%"></div>
        </div>
      </div>
    </div>
    <div class="view_cny">≈ 4.99 CNY</div>
    <div class="shuliang">
      <span class="position">
        <el-input placeholder="请输入内容" class="shuliang_input"></el-input>
        <span class="filda">FILDA</span>
      </span>
    </div>
  </div>
</template>

<script>
export default {
  name: "Trade",
  data() {
    return {
      num: 1,
      options: [
        {
          value: "选项1",
          label: "黄金糕",
        },
        {
          value: "选项2",
          label: "双皮奶",
        },
        {
          value: "选项3",
          label: "蚵仔煎",
        },
        {
          value: "选项4",
          label: "龙须面",
        },
        {
          value: "选项5",
          label: "北京烤鸭",
        },
      ],
      value: "",
    };
  },
  components: {},
  methods: {},
};
</script>
<style  lang="scss">
@import "../../assets/styles/Trade/Trade";
</style>
