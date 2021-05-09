<template>
  <div class="ChartChild">
    <div class="nav">
      <!-- <span class="nav_text nav_active">分时</span> -->
      <span class="nav_text nav_active">15分</span>
      <span class="nav_text">1小时</span>
      <span class="nav_text">4小时</span>
      <span class="nav_text">日线</span>
      <span class="nav_text addicon"
        ><span>更多</span><i class="iconfont icon-more1"></i
      ></span>
    </div>
    <div class="line"></div>
    <div id="main" style="width: 100%; height: 400px; min-height: 200px"></div>
    <div class="line"></div>
  </div>
</template>
<script>
import * as echarts from "echarts/core";
import {
  ToolboxComponent,
  TooltipComponent,
  GridComponent,
  VisualMapComponent,
  LegendComponent,
  BrushComponent,
  DataZoomComponent,
  TitleComponent,
  TimelineComponent,
  CalendarComponent,
} from "echarts/components";
import { CandlestickChart, LineChart, BarChart } from "echarts/charts";
import { CanvasRenderer } from "echarts/renderers";

echarts.use([
  ToolboxComponent,
  TooltipComponent,
  GridComponent,
  VisualMapComponent,
  LegendComponent,
  BrushComponent,
  DataZoomComponent,
  CandlestickChart,
  LineChart,
  BarChart,
  CanvasRenderer,
  TitleComponent,
  TimelineComponent,
  CalendarComponent,
]);
var ROOT_PATH =
  "https://cdn.jsdelivr.net/gh/apache/echarts-website@asf-site/examples";

var option;

var upColor = "#00da3c";
var downColor = "#ec0000";
export default {
  name: "ChartChild",
  data() {
    return {};
  },
  mounted() {
    this.$nextTick(() => {
      this.drawLine();
    });
  },
  methods: {
    drawLine() {
      var chartDom = document.getElementById("main");
      let skin = localStorage.getItem("Skin");
      var myChart = echarts.init(chartDom, skin);

      this.$axios
        .get(ROOT_PATH + "/data/asset/data/stock-DJI.json")
        .then((rawData) => {
          var data = this.splitData(rawData.data);
          myChart.setOption(
            (option = {
              animation: false,
              legend: {
                bottom: 100,
                data: ["MA5", "MA10", "MA20", "MA30"],
                left: 0,
              },
              tooltip: {
                trigger: "axis",
                axisPointer: {
                  type: "cross",
                },
                backgroundColor: "rgba(00, 00, 00, 0.8)",
                borderWidth: 1,
                borderColor: "#ccc",
                padding: 10,
                textStyle: {
                  color: "#fff",
                  fontSize: 8,
                },
                position: function (pos, params, el, elRect, size) {
                  var obj = { top: 10 };
                  obj[["left", "right"][+(pos[0] < size.viewSize[0] / 2)]] = 30;
                  return obj;
                },
                // extraCssText: 'width: 170px'
              },
              axisPointer: {
                link: { xAxisIndex: "all" },
                label: {
                  backgroundColor: "#777",
                },
              },
              // toolbox: {
              //   feature: {
              //     dataZoom: {
              //       yAxisIndex: false,
              //     },
              //     brush: {
              //       type: ["lineX", "clear"],
              //     },
              //   },
              // },
              visualMap: {
                show: false,
                seriesIndex: 5,
                dimension: 2,
                pieces: [
                  {
                    value: 1,
                    color: upColor,
                  },
                  {
                    value: -1,
                    color: downColor,
                  },
                ],
              },
              // brush: {
              //   xAxisIndex: "all",
              //   brushLink: "all",
              //   outOfBrush: {
              //     colorAlpha: 0.1,
              //   },
              // },
              // visualMap: {
              //   show: false,
              //   seriesIndex: 5,
              //   dimension: 2,
              //   pieces: [
              //     {
              //       value: 1,
              //       color: downColor,
              //     },
              //     {
              //       value: -1,
              //       color: upColor,
              //     },
              //   ],
              // },
              grid: [
                {
                  left: 0,
                  right: 0,
                  height: "65%",
                  width: "100%",
                  top: "10px",
                },
                {
                  left: 0,
                  right: 0,
                  top: "70%",
                  height: "16%",
                  width: "100%",
                },
              ],
              xAxis: [
                {
                  type: "category",
                  data: data.categoryData,
                  scale: true,
                  boundaryGap: false,
                  axisLine: { onZero: false },
                  axisTick: { show: false },
                  splitLine: { show: true },
                  axisLabel: { show: false },
                  splitNumber: 20,
                  min: "dataMin",
                  max: "dataMax",
                  axisPointer: {
                    z: 100,
                  },
                },
                {
                  type: "category",
                  gridIndex: 1,
                  data: data.categoryData,
                  scale: true,
                  boundaryGap: false,
                  axisLine: { onZero: false },
                  axisTick: { show: false },
                  splitLine: { show: false },
                  axisLabel: { show: true },
                  splitNumber: 20,
                  min: "dataMin",
                  max: "dataMax",
                },
              ],
              yAxis: [
                {
                  type: "value",
                  position: "right",
                  offset: -55,
                  nameLocation: "end",
                  scale: true,
                  splitArea: {
                    show: true,
                  },
                },
                {
                  scale: true,
                  gridIndex: 1,
                  splitNumber: 2,
                  axisLabel: { show: false },
                  axisLine: { show: false },
                  axisTick: { show: false },
                  splitLine: { show: false },
                },
              ],
              dataZoom: [
                {
                  type: "inside",
                  xAxisIndex: [0, 1],
                  start: 98,
                  end: 100,
                },
                {
                  show: true,
                  xAxisIndex: [0, 1],
                  type: "slider",
                  top: "85%",
                  start: 98,
                  end: 100,
                },
              ],
              series: [
                {
                  name: "指数",
                  type: "candlestick",
                  data: data.values,
                  itemStyle: {
                    color: downColor,
                    color0: upColor,
                    borderColor: null,
                    borderColor0: null,
                  },
                  tooltip: {
                    formatter: function (param) {
                      param = param[0];
                      return [
                        "Date: " +
                          param.name +
                          '<hr size=1 style="margin: 3px 0">',
                        "open: " + param.data[0] + "<br/>",
                        "close: " + param.data[1] + "<br/>",
                        "lowest: " + param.data[2] + "<br/>",
                        "highest: " + param.data[3] + "<br/>",
                      ].join("");
                    },
                  },
                },
                {
                  name: "MA5",
                  type: "line",
                  data: this.calculateMA(5, data),
                  smooth: true,
                  lineStyle: {
                    opacity: 0.5,
                    width: 1,
                  },
                },
                {
                  name: "MA10",
                  type: "line",
                  data: this.calculateMA(10, data),
                  smooth: true,
                  symbol: "none",
                  lineStyle: {
                    opacity: 0.5,
                    width: 1,
                  },
                },
                {
                  name: "MA20",
                  type: "line",
                  data: this.calculateMA(20, data),
                  smooth: true,
                  symbol: "none",
                  lineStyle: {
                    opacity: 0.5,
                    width: 1,
                  },
                },
                {
                  name: "MA30",
                  type: "line",
                  data: this.calculateMA(30, data),
                  smooth: true,
                  symbol: "none",
                  lineStyle: {
                    opacity: 0.5,
                    width: 1,
                  },
                },
                {
                  name: "成交量",
                  type: "bar",
                  xAxisIndex: 1,
                  yAxisIndex: 1,
                  data: data.volumes,
                },
              ],
            }),
            true
          );

          myChart.dispatchAction({
            type: "brush",
            areas: [
              {
                brushType: "lineX",
                coordRange: ["2016-06-02", "2016-06-20"],
                xAxisIndex: 0,
              },
            ],
          });
          //myChart.dispatchAction();
        });

      option && myChart.setOption(option);
    },
    splitData(rawData) {
      var categoryData = [];
      var values = [];
      var volumes = [];
      for (var i = 0; i < rawData.length; i++) {
        categoryData.push(rawData[i].splice(0, 1)[0]);
        values.push(rawData[i]);
        volumes.push([
          i,
          rawData[i][4],
          rawData[i][0] > rawData[i][1] ? 1 : -1,
        ]);
      }

      return {
        categoryData: categoryData,
        values: values,
        volumes: volumes,
      };
    },
    calculateMA(dayCount, data) {
      var result = [];
      for (var i = 0, len = data.values.length; i < len; i++) {
        if (i < dayCount) {
          result.push("-");
          continue;
        }
        var sum = 0;
        for (var j = 0; j < dayCount; j++) {
          sum += data.values[i - j][1];
        }
        result.push(+(sum / dayCount).toFixed(3));
      }
      return result;
    },
  },
};
</script>
<style lang="scss" scoped>
@import "../../assets/styles/Chart/ChartChild";
</style>