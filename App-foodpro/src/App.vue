<template>
  <router-view />
  <div class="nav">
    <router-link to="/" active-class="actived">
        <img class="one" src="~assets/images/icon-footer/icon-foods.png">
        <img class="two" src="~assets/images/icon-footer/icon-foods-active.png">
    </router-link>
    <router-link to="/recipe" active-class="actived">
        <img class="one" src="~assets/images/icon-footer/icon-recipe.png">
        <img class="two" src="~assets/images/icon-footer/icon-recipe-active.png">
    </router-link>
    <router-link to="/friends" active-class="actived">
        <img class="one" src="~assets/images/icon-footer/icon-friends.png">
        <img class="two" src="~assets/images/icon-footer/icon-friends-active.png">
    </router-link>
    <router-link to="/settings" active-class="actived">
        <img class="one" src="~assets/images/icon-footer/icon-settings.png">
        <img class="two" src="~assets/images/icon-footer/icon-settings-active.png">
    </router-link>
  </div>
</template>


<style lang="scss">
    @import "assets/css/base.css";
    #app {
        /*font-family: Avenir, Helvetica, Arial, sans-serif;*/
        font-family: 'Futura';
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
        text-align: center;
        color: #2c3e50;
    }

    .nav{
        display: flex;
        justify-content: space-around;
        align-items: center;
        background-color: var(--bg-color);
        border-radius: var(--border-radius-base) var(--border-radius-base) 0 0 ;
        box-shadow: 0.125rem 0.125rem 1.125rem #dddddd;
        position: fixed;
        bottom: 0;
        width: 100vw;
        height: 3rem;

        img{
            width: var(--img-size-sm);
            height: var(--img-size-sm);
        }
        .one{
            display: block;
        }
        .two{
            display: none;
        }
    }
    .actived>:first-child{
        display: none;
    }
    .actived>:last-child{
        display: block;
    }

</style>
