<template>
    <div class="main">
        <div class="header">
            <img src="~assets/images/icon-bar/icon-back.png" @click="goback">
            <strong>Recipe</strong>
            <img src="~assets/images/icon-bar/icon-more.png">
        </div>
        <div class="box">
            <chat-recipe v-for="(item,index) in messages" :key="index" :chat="item"></chat-recipe>
            <div class="input-box">
                <input type="text" v-model="words">
                <img src="~assets/images/avatar/send.png" @click="findRecipe">
            </div>
        </div>
    </div>
</template>

<script>
    import {useRouter} from 'vue-router';
    import {ref,onMounted} from 'vue';
    import {foods,recipes} from 'data/data.js';
    import chatRecipe from "components/chatRecipe";
    export default {
        name: "Recipe",
        components: {
            chatRecipe
        },
        setup(){
            const router=useRouter();
            let messages= ref([]);
            let words=ref('');
            let id=ref(1);
            //users provide food name
            let uFoods=ref([]);
            //robot 1st reply 
            let ans=ref('');
            //recipes corresponding to ingredients
            let recipe=ref({});
            onMounted(()=>{
                messages.value.push({
                    id:id.value,
                    isRobot:true,
                    imgSrc:require('@/assets/images/avatar/robot.png'),
                    words:'Welcome! What do you want to cook today?',
                    hasRecipe:false,
                    rImg:'',
                    rMsg1:'',
                    rMsg2:''
                })
            })
            const goback=()=>{
                router.go(-1);
            }
            const findRecipe=()=>{
                if(words.value!=''){
                    //generate recipe
                    showUser();
                    //filtering food
                    let allWords=words.value.split(' ');
                    uFoods.value=allWords.filter((item)=>{
                        return foods.some((value)=>{
                            return value.name.toLowerCase() == item.toLowerCase();
                        })
                    });
                    //preset reply
                    ans.value=uFoods.value.map((item,index)=>{
                        item=`${index+1}.${item}`;
                        return item;
                    }).join('\n')||'nothing';

                    //clear text
                    words.value='';
                    //robot 1st reply
                    showRobot1();

                    //finding recipe
                    recipe.value=recipes.filter((item)=>{
                        return item.foods.sort().toString()==uFoods.value.sort().toString();
                    })
                    //robot 2nd reply
                    if(ans.value!='nothing') {
                        if(recipe.value.length==0){
                            showRobot3();
                        }
                        else showRobot2();
                    }
                }
            }
            //display user text
            const showUser=()=>{
                id.value+=1;
                messages.value.push({
                    id:id.value,
                    isRobot:false,
                    imgSrc:require('@/assets/images/avatar/user.png'),
                    words:words.value,
                    hasRecipe:false,
                    rImg:'',
                    rMsg1:'',
                    rMsg2:''
                })
            }
            //display robot 1st reply
            const showRobot1=()=>{
                id.value+=1;
                messages.value.push({
                    id:id.value,
                    isRobot:true,
                    imgSrc:require('@/assets/images/avatar/robot.png'),
                    words:'What you got are:\n'+ans.value+'\nSearching the database...',
                    hasRecipe:false,
                    rImg:'',
                    rMsg1:'',
                    rMsg2:''
                })
            }
            //display robot 2nd reply
            const showRobot2=()=>{
                id.value+=1;
                messages.value.push({
                    id:id.value,
                    isRobot:true,
                    imgSrc:require('@/assets/images/avatar/robot.png'),
                    words:'The following is the recipe I found for you:',
                    hasRecipe:true,
                    rImg:recipe.value[0].img,
                    rMsg1:recipe.value[0].name,
                    rMsg2:recipe.value[0].msg
                })
            }
            //display robot reply(no recipe)
            const showRobot3=()=>{
                id.value+=1;
                messages.value.push({
                    id:id.value,
                    isRobot:true,
                    imgSrc:require('@/assets/images/avatar/robot.png'),
                    words:'There is no recipe!',
                    hasRecipe:false,
                    rImg:'',
                    rMsg1:'',
                    rMsg2:''
                })
            }
            return {
                goback,
                words,
                findRecipe,
                messages
            }
        }
    }
</script>

<style lang="scss" scoped>
    .main{
        .header{
            position: fixed;
            background-color: var(--bg-yellow);
            width: 100vw;
            padding: 0.75rem 0.75rem 1rem 0.75rem;
            display: flex;
            justify-content: space-between;
            img{
                width: var(--img-size-sm);
                height: var(--img-size-sm);
            }
            strong{
                color: var(--text-color-inverse);
                font-size: 18px;
            }
        }
        .box{
            height: 100%;
            /*background-color: var(--bg-color-grey);*/
            padding: 4rem 0 5rem 0;
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
            .input-box{
                position: fixed;
                bottom: 4rem;
                input{
                    width: 100vw;
                    outline:none;
                    padding: 0.4rem 3rem 0.4rem 1rem;
                    border:1px solid #e8e8e8;
                }
                img{
                    position: absolute;
                    right: 0;
                    width: 2rem;
                    height: 2rem;
                    background-color: var(--bg-yellow);
                }
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