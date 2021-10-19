<template>
    <div class="main">
        <img class="left" :src="food.imgSrc">
        <div class="right">
            <div class="detail">
                <div>{{food.name}}</div>
                <div>Added in {{food.added}}</div>
                <div :id="food.id">Expired in {{food.expired}} days</div>
            </div>
            <img class="edit" src="~assets/images/icon-card/edit.png">
            <img class="share" src="~assets/images/icon-card/share.png">
        </div>

    </div>
</template>

<script>
    import {ref,onMounted} from 'vue';
    export default {
        name: "card",
        props:{
            food:{
                type:Array,
                default(){
                    return [];
                }
            }
        },
        //food status
        setup(props){
            onMounted(()=>{
                let remaind=document.getElementById(props.food.id);
                //expire soon
                if(props.food.expired<=2){
                    remaind.classList.add('red');
                }
                //about to expire
                if(props.food.expired<=5&&props.food.expired>2){
                    remaind.classList.add('yellow');
                }
                //fresh 
                if(props.food.expired>5){
                    remaind.classList.add('green');
                }
            })
        }
    }
</script>

<style lang="scss" scoped>
    .main{
        position: relative;
        border-radius: var(--border-radius-sm);
        margin: 1rem;
        display: flex;
        box-shadow: 0.2rem 0.2rem 1rem #e8e8e8;
        padding: 0.5rem;
        height: 5.6rem;
        .left{
            width: var(--img-size-lg);
            height: var(--img-size-lg);
            border-radius: var(--border-radius-sm);
        }
        .right{
            padding: 0.2rem 0 0 1.4rem;
            .detail{
                display: flex;
                flex-direction: column;
                align-items: flex-start;
            }
            .detail>:nth-of-type(1){

                font-size: 21px;
                color: var(--text-color);
                margin-bottom: 5px;
            }
            .detail>:nth-of-type(2){
                font-size: 13px;
                color: var(--text-color-grey);
                margin-bottom: 5px;
            }
            .detail>:nth-of-type(3){
                font-size: 14px;
            }
            .edit{
                position: absolute;
                right: 0.5rem;
                top: 0.5rem;
                width: var(--img-size-sm);
                height: var(--img-size-sm);
            }
            .share{
                position: absolute;
                right: 2.5rem;
                top: 0.5rem;
                width: var(--img-size-sm);
                height: var(--img-size-sm);
            }

        }
    }

    .green{
        color: var(--color-success);
    }
    .yellow{
        color: var(--color-primary)
    }
    .red{
        color: var(--color-warning);
    }
</style>
