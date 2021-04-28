import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    component:() => import('../views/index.vue') ,
    children: [
      {
        path: '',
        redirect: '/home'
      },
      {
        path: '/home',
        name: 'Transaction',
        component: () => import('../views/Transaction.vue')
      },
      {
        path: '/swap',
        name: 'Swap',
        component: () => import('../views/Swap.vue')
      },
     
    ]
  },
 
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
