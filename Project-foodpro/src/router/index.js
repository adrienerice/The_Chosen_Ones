import { createRouter, createWebHistory } from 'vue-router'
const Foods= ()=>import('views/foods/Foods')
const Recipe= ()=>import('views/recipe/Recipe')
const routes = [
  {
    path: '/',
    name: 'Foods',
    component: Foods
  },
  {
    path: '/recipe',
    name: 'Recipe',
    component: Recipe
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
