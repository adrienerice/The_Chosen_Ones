<template>
    <div class="main">
        <div class="header">
            <img class="img-left" src="~assets/images/icon-bar/icon-list.png">
            <img class="img-right" src="~assets/images/icon-bar/icon-camera.png">
        </div>
        <div class="search">
            <input class="input" type="text" v-model="name">
            <img src="~assets/images/icon-bar/icon-search.png" @click="search()">
        </div>
        <div class="class">
            <div class="class-box" @click="type('all')">
                <img src="~assets/images/icon-class/1.png">
                <span>All</span>
            </div>
            <div class="class-box" @click="type('fruits')">
                <img src="~assets/images/icon-class/2.png">
                <span>Fruits</span>
            </div>
            <div class="class-box" @click="type('vegetable')">
                <img src="~assets/images/icon-class/3.png">
                <span>Vegetable</span>
            </div>
            <div class="class-box" @click="type('meat')">
                <img src="~assets/images/icon-class/4.png">
                <span>Meat</span>
            </div>
        </div>

        <card v-for="item in food" :key="item" :food="item"></card>
    </div>
</template>

<script>
    import Card from "../../components/card";
    import {foods} from "../../data/data.js";
    import {ref,reactive} from 'vue';
    export default {
        name: "Foods",
        setup(){
            let food=ref([]);
            let name=ref('');
            food.value=foods;
            let search=()=>{
                if(name.value!='') {
                    food.value = foods.filter((item) => {
                        return item.name.toLowerCase() == name.value.toLowerCase();
                    })
                }else food.value=foods;
            }
            let type=(type)=>{
                if(type!='all'){
                    food.value = foods.filter((item) => {
                        return item.type.toLowerCase() == type;
                    })
                }else food.value=foods;
            }
            return{
                food,
                name,
                search,
                type
            }
        },
        components: {Card}
    }
</script>

<style lang="scss" scoped>
.main{
    padding-bottom: 3rem;
    .header{
        background-color: var(--bg-yellow);
        width: 100vw;
        padding: 0.75rem 0.75rem 5rem 0.75rem;
        img {
            width: var(--img-size-sm);
            height: var(--img-size-sm);
        }
        .img-left{
            float: left;
        }
        .img-right{
            float: right;
        }
    }
    .search{
        .input{
            position: relative;
            left: var(--img-offset);
            transform: translateY(-50%);
            padding: 0.6rem 2.1rem 0.6rem 0.8rem;
            outline:none;
            border:0px;
            box-shadow: 0rem 0.125rem 0.2rem #edeeee;
            border-radius: 0.2rem;
        }
        img {
            position: relative;
            right: 1.2rem;
            bottom: var(--img-offset);
            width: var(--img-size-sm);
            height: var(--img-size-sm);
        }
    }
    .class{
        display: flex;
        justify-content: space-around;
        .class-box{
            display: flex;
            flex-direction: column;

            img{
                width: var(--img-size-base);
                height: var(--img-size-base);
            }
            span{
                color: var(--text-color-grey);
                padding-top: 0.225rem;
                font-size: var(--font-size-sm);
            }
        }
    }
}
</style>