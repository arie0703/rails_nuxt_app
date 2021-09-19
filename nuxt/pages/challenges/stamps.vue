<template>
    <v-container class="stamp-container">
        <v-row v-for="r in row" :key="r">
            <img v-for="n in 5" :key="n" src="/stamp.png" width="50">
        </v-row>

        <v-row>
            <img v-for="n in reminder" :key="n" src="/stamp.png" width="50">
        </v-row>
    </v-container>
</template>

<style scoped>
.stamp-container {
    height: 200px;
    background-color: rgba(40,40,40,0.8);
    padding: 20px;
    border-radius: 5px;
}
</style>

<script>
export default {
    props: {
        cleared: Number
    },
    data: () => {
        return {
            num: 0,
            row: 0,
            reminder: 0,
        }
    },
    mounted() {
        this.setNumber,
        this.setStampCard()
    },
    computed: {
        setNumber () {
            return this.num = this.cleared
        }
    },
    watch: {
        cleared: function(newVal) { //Doneが押された時にclearedの変更を感知・スタンプが押される処理発火
            console.log(newVal) 
            this.cleared = newVal
            this.setNumber
            this.setStampCard()
        }
    },
    methods: {
        setStampCard() {
            this.row = Math.floor(this.num / 5)
            this.reminder = this.num % 5

            console.log(this.row, this.reminder)
        },
    }
    

}
</script>