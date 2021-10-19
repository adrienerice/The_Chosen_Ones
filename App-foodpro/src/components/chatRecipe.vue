<template>
    <div :id="chat.id" class="inside">
        <div class="avatar">
            <img :src="chat.imgSrc">
        </div>
        <div class="words-box">
            <div class="words">
                <span :id='`s${chat.id}`'></span>
                <div :id='`r${chat.id}`' class="recipe">
                    <img :src="chat.rImg">
                    <div class="detail">
                        <strong>{{chat.rMsg1}}</strong><br/>
                        <span>{{chat.rMsg2}}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import {ref,onMounted} from 'vue';
    export default {
        name: "recipe",
        props:{
            chat:{
                type:Object,
                default(){
                    return {};
                }
            }
        },
        setup(props){
            onMounted(()=>{
                let main = document.getElementById(''+props.chat.id);
                let recipe=document.getElementById('r'+props.chat.id);
                let span=document.getElementById('s'+props.chat.id);
                span.innerText=props.chat.words;
                if (props.chat.isRobot) main.classList.add('robot');
                else main.classList.add('user');
                if(props.chat.hasRecipe) recipe.style.display="block";
                else recipe.style.display="none";
            })
        }
    }
</script>

<style lang="scss" scoped>
    .inside{
        padding:0 0.75rem 1.3rem 0.75rem;
        .avatar{
            img{
                width: var(--img-size-base);
                height: var(--img-size-base);
                border-radius: var(--border-radius-base);
            }
        }
        .words-box{
            text-align: left;
            .words{
                padding: 0.525rem;
                box-shadow: 0.125rem 0.125rem 0.27rem #e3e4e4;
                border-radius: var(--border-radius-base);
            }
        }
    }
    .robot{
        img{
            float: left;
        }
        .words-box{
            margin-left: var(--img-size-base);
            padding: 0.2rem var(--img-size-base) 0 0.33rem;
            .words{
                background-color: white;
                border-top-left-radius:0 !important;
                .recipe{
                    height: var(--img-size-lg);
                    border-radius: var(--border-radius-sm);
                    overflow: hidden;
                    background-color: var(--bg-color-grey);
                    border: 1px solid #eee;
                    img{
                        width: var(--img-size-lg);
                    }
                    .detail{
                        padding: 0 0.4rem;
                        text-overflow:ellipsis;
                        overflow:hidden;
                        -webkit-line-clamp:4;
                        display: -webkit-box;
                        -webkit-box-orient:vertical;
                    }
                    .detail>:first-child{
                        font-size: var(--font-size-base);
                    }
                    .detail>:last-child{
                        font-size: var(--font-size-sm);
                    }
                }
            }
        }
    }
    .user{
        img{
            float: right;
        }
        .words-box{
            margin-right: var(--img-size-base);
            padding: 0.2rem 0.33rem 0 var(--img-size-base);
            .words{
                background-color: var(--bg-yellow);
                border-top-right-radius:0 !important;
            }
        }
    }
</style>