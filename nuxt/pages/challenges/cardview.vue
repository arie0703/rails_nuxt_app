<template>
    <v-container>
        <v-card-text>
            {{ challenge.title }}
            <v-btn
            icon
            class="float-right delete-btn"
            @click="showAlert = true"
            >
                <v-icon>mdi-minus</v-icon>
            </v-btn>

        </v-card-text>

        <v-card-text>
            達成日数: {{ challenge.cleared}} 
            継続: {{ challenge.continuation }}

        </v-card-text>

        <Stamps :cleared="challenge.cleared" :goal="challenge.goal"></Stamps>

        <div class="private-area" v-if="$auth.user.id == $route.params.id && !challenge.is_done">


            <div v-if="challenge.is_started || challenge.done_at">
                <v-card-text>{{ challenge.done_at }}</v-card-text>
                <v-btn 
                @click="pushDone(challenge.id, challenge.cleared, challenge.continuation, challenge.done_at, challenge.goal)"
                v-if="!isDoneToday(challenge.done_at)"
                >
                    Done
                </v-btn>

                <p v-if="isDoneToday(challenge.done_at)">今日は達成済み</p>
                <p>{{challenge.is_done}}</p>
            </div>

            <div v-if="!challenge.is_started && !challenge.done_at">
                <v-card-text>ボタンを押してスタート！</v-card-text>
                <v-btn @click="start(challenge.id)">START</v-btn>
            </div>
        </div>

        <div class="ended" v-if="challenge.is_done == true">
            <v-card-text>達成済み</v-card-text>
        </div>


        <v-dialog
        v-model="showAlert"
        width="500"
        >
            
            <v-card-text v-if="showAlert">
                <v-alert
                    color="orange"
                    type="info"
                >
                削除したら戻せないよ！
                <p>id: {{challenge.id}}</p>
                </v-alert>
                <v-btn @click="destroy()">削除</v-btn>
                <v-btn v-on:click="showAlert=false">キャンセル</v-btn>
            </v-card-text>
            
        </v-dialog>
    </v-container>
</template>

<style scoped>
.v-dialog {
    background: #333;
}

.delete-btn {
    margin: -6px;
}
</style>

<script>
import Stamps from './stamps.vue'
export default {
    name: "CardView",
    props: {
        challenge: Object,
        today: Date,
        yesterday: Date,
    },
    components: {
        Stamps,
    },
    data: () => {
        return {
            continuation: 0,
            cleared: 0,
            showAlert: false,
        }
    },
    computed: {
        params() {
            return {
                challenge: {
                    cleared: this.cleared,
                    continuation: this.continuation,
                    done_at: null,
                    is_started: true,
                    is_done: false,
                }
            }
        },
        isDoneToday: function() { // v-ifで引数を渡せるようにしておく
            self = this;
            return function (done_at) {
                if (done_at) {
                    done_at = new Date(done_at)
                    if (done_at > this.today) {
                        return true
                    }
                }
                return false
            }
        }
    },
    watch: {
        challenge: function(newVal) { 
            console.log(newVal) 
            this.challenge = newVal
        }
    },
    methods: {
        start(id) {
            const url = `/api/v1/challenges/${id}`

            //paramsの値をしっかり初期値にしておく
            this.params.challenge.done_at = null 
            this.params.challenge.cleared = 0
            this.params.challenge.continuation = 0
            this.params.challenge.is_done = false

            this.$axios.put(url, this.params)
                .then((res) => {
                    this.updateData() // challengesを再取得  
                })
                .catch((err) => {
                    console.log("error.")
                })  
        },
        destroy() {
            const url = `/api/v1/challenges/${this.challenge.id}`
            this.$axios.delete(url)
                .then(() => {
                    this.updateData()
                    this.showAlert = false;
                    console.log("success")
                })
                .catch((err) => {
                    const message = err.response.data
                    this.$bvToast.toast(message, {
                        title: 'エラー',
                        variant: 'danger'
                    })
                })
            this.updateData()
            this.showAlert = false;
        },
        pushDone(id, cleared, continuation, done_at, goal) {
            const url = `/api/v1/challenges/${id}`
            this.params.challenge.cleared = cleared + 1
            done_at = new Date(done_at); // jsonのdateをjsのDateに変換

            console.log(goal, this.params.challenge.cleared)
            if (done_at < this.yesterday) { //Doneが押された時の昨日の日付とdone_atを比較
                continuation = 0 //最後のDoneが昨日より前と判定されたら、continuationを一旦0にする
            }

            this.params.challenge.continuation = continuation + 1
            this.params.challenge.done_at = new Date()
            console.log(this.params.challenge.done_at)

            if (this.params.challenge.cleared >= goal) { // clearedが目標日数をに到達したら終了
                this.params.challenge.is_done = true
                console.log("終了")
            } else {
                this.params.challenge.is_done = false
            }

            

            console.log(this.params)
            this.$axios.put(url, this.params)
                .then((res) => {
                    console.log("yeah");
                    this.updateData() // challengesを再取得  
                })
                .catch((err) => {
                    console.log("error.")
                })  
        },
        updateData() {
            this.$emit('updateData');
            // 親コンポーネント（user/_id）のgetMyChallengesを発火させる
        },

    }
    
}
</script>