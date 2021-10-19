export let foods=[
            {
                id:'001',
                name: 'Beef',
                imgSrc: require('assets/images/foods/beef.png'),
                added:'9/12',
                expired:2,
                type:'meat'
            },
            {
                id:'002',
                name: 'Chili',
                imgSrc: require('assets/images/foods/chili.png'),
                added:'9/7',
                expired:5,
                type:'vegetable'
            },
            {
                id:'003',
                name: 'Banana',
                imgSrc: require('assets/images/foods/banana.png'),
                added:'9/12',
                expired:4,
                type:'fruits'
            },
            {
                id:'004',
                name: 'Shrimp',
                imgSrc: require('assets/images/foods/shrimp.png'),
                added:'9/10',
                expired:7,
                type:'vegetable'
            },
            {
                id:'005',
                name: 'Tomato',
                imgSrc: require('assets/images/foods/tomato.png'),
                added:'9/7',
                expired:1,
                type:'vegetable'
            },
            {
                id:'006',
                name: 'Eggs',
                imgSrc: require('assets/images/foods/eggs.png'),
                added:'9/13',
                expired:6,
                type:'meat'
            }

        ];
export let recipes=[
    {
        name:'Slow Cooker Beef Stew',
        foods:['beef','tomato'],
        img:require('assets/images/recipes/beef-stew.png'),
        msg:"Beef soup, don't say drink, just let you smell, it will make you salivate, can't stop."
    },
    {
        name:'Tomato scrambled eggs',
        foods:['eggs','tomato'],
        img: require('assets/images/recipes/eggs-tomato.png'),
        msg:'Bright colors, sweet and sour, smooth taste, rich color fragrance, increase appetite. Tomato scrambled eggs'
    }

]