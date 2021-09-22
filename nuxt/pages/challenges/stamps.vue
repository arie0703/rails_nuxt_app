<template>
    <v-container class="stamp-container">
        <v-row v-for="r in row" :key="r">
            <div v-for="n in 5" :key="n" class="stamp-area">
                <img class="stamp" v-if="cleared >= (r - 1) * 5 + n" src="/stamp.png" width="40">
                <p class="stamp-number" v-if="cleared < (r - 1) * 5 + n && (r - 1) * 5 + n < goal">{{ (r - 1) * 5 + n }}</p>
                <div class= "goal" v-if="(r - 1) * 5 + n == goal && cleared < goal">
                    GOAL
                </div>
            </div>
        </v-row>

        <v-row>
            <div v-for="n in reminder" :key="n" class="stamp-area">
                <img class="stamp" v-if="cleared >= (goal - reminder) + n" src="/stamp.png" width="40">
                <p class="stamp-number" v-if="cleared < (goal - reminder) + n && (goal - reminder) + n < goal">{{ (goal - reminder) + n }}</p>

                <div class= "goal" v-if="n == reminder && cleared < goal">
                    GOAL
                </div>
            </div>
        </v-row>
    </v-container>
</template>

<style scoped>
.stamp-container {
    height: 300px;
    background-color: rgba(40,40,40,0.8);
    padding: 20px;
    border-radius: 5px;
}

.stamp-area {
  background-color: rgba(60,60,60,0.8);
  width: 45px;
  height: 45px;
  margin: 1px;
}

.stamp {
    text-align: center;
    margin: 2.5px;
}

.stamp-number {
    text-align: center;
    line-height: 30px;
    background-color: #444;
    width: 30px;
    height: 30px;
    margin: 7.5px;
    border-radius: 50%;
    color: #777;
}

.goal {
  width: 40px;
  height: 40px;
  margin: 2.5px;
  line-height: 40px;
  text-align: center;
  background: darkcyan;
  font-size: 80%;
  border-radius: 50%;
}
</style>

<script>
export default {
    props: {
        cleared: Number,
        goal: Number
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
            
            return this.num = this.goal;
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