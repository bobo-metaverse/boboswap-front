import Vue from 'vue'
import App from './App.vue'
import router from './router'
import {store} from './store/index'
import i18n from './vueI18n/i18n'
import axios from 'axios'
import qs from 'qs'

require('./assets/font/Source Han Sans CN Regular.css');
require ('./assets/iconfont/iconfont.css')
require('./assets/js/element')


Vue.config.productionTip = false
Vue.prototype.$axios = axios

axios.defaults.baseURL = '';

// 请求拦截
axios.interceptors.request.use(
  config => {
    if (config.method == 'post') {
      config.data = qs.stringify(config.data);
    }

    return config;
  },
  error => {
    return Promise.reject(error);
  }
);

// 响应拦截
axios.interceptors.response.use(
  response => {
    return response;
  },
  error => {
    // 错误提醒
    return Promise.reject(error);
  }
);

new Vue({
  router,
  store,
  i18n,
  render: h => h(App)
}).$mount('#app')
