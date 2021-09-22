<template>
    <v-container>
        <p>{{user.name}}さんのマイページ</p>
        <p>{{user.email}}</p>

        <strong>マイチャレンジ</strong>
        <v-row>
            <v-card
            v-for="challenge in challenges"
            :key="challenge.id"
            width="275"
            class="stamp-card"
            >
                <v-container>
                    <v-card-text>{{ challenge.title }}</v-card-text>
                    <v-card-text>
                        達成日数: {{ challenge.cleared}} 
                        継続: {{ challenge.continuation }}

                    </v-card-text>

                    <Stamps :cleared="challenge.cleared" :goal="challenge.goal"></Stamps>

                    <div class="private-area" v-if="$auth.user.id == $route.params.id">


                        <div v-if="challenge.is_started || challenge.done_at">
                            <v-card-text>{{ challenge.done_at }}</v-card-text>
                            <v-btn 
                            @click="pushDone(challenge.id, challenge.cleared, challenge.continuation, challenge.done_at, challenges.indexOf(challenge))"
                            v-if="!isDoneToday(challenge.done_at)"
                            >
                                Done
                            </v-btn>

                            <p v-if="isDoneToday(challenge.done_at)">今日は達成済み</p>
                        </div>

                        <div v-if="!challenge.is_started && !challenge.done_at">
                            <v-card-text>ボタンを押してスタート！</v-card-text>
                            <v-btn @click="start(challenge.id)">START</v-btn>
                        </div>
                    </div>
                </v-container>
            </v-card>
        </v-row>
    </v-container>
</template>

<style scoped>
.v-card {
    margin: 10px;
}
</style>
<script>
import Stamps from '../challenges/stamps.vue'
export default {
    auth: false,
    components: {
        Stamps
    },
    data: () => {
        return {
            user: {},
            challenges: [],
            continuation: 0,
            cleared: 0,
            yesterday: new Date(),
            today: new Date(),
        }
    },
    mounted() {
        this.setDate()
        this.fetchContent()
        this.getMyChallenges()
    },
    computed: {
        params() {
            return {
                challenge: {
                    cleared: this.cleared,
                    continuation: this.continuation,
                    done_at: null,
                    is_started: true,
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
    methods: {
        fetchContent() {
            const url = `/api/v1/auth/user/${this.$route.params.id}`
            this.$axios.get(url)
            .then((res) => {
                this.user = res.data
                // console.log(res.data)
            })
            .catch(() => {
                console.log("error");
            })
        },
        setDate() {
            this.yesterday.setDate(this.yesterday.getDate() - 1);
            this.yesterday.setHours(0, 0, 0, 0);
            this.today.setHours(0, 0, 0, 0);
        },
        getMyChallenges() {
            const url = `/api/v1/challenges?user_id=${this.$route.params.id}`
            this.$axios.get(url)
                .then((res) => {
                console.log("データ更新メソッドが発火")
                console.log(res.data);
                console.log(this.yesterday)
                for(let i = 0; i < res.data.length; i++) { // ここで最後にDoneボタンを押したのが昨日より前かを判定
                    var last_done = new Date(res.data[i].done_at) // jsで

                    console.log(last_done, res.data[i].done_at)
                    
                    if(this.yesterday > last_done && res.data[i].continuation > 0) { //もし最後の更新が昨日以前なら
                        this.toZero(res.data[i].id, res.data[i].cleared, res.data[i].done_at) // continuationを0にするメソッド発火
                    } else {
                        console.log(last_done, this.yesterday, "計算できてない")
                    }
                    
                }
                this.challenges = res.data
                })
                .catch((err) => {
                console.log("error.")
                })
        },
        toZero(id, cleared, done_at) {
            const url = `/api/v1/challenges/${id}`
            this.params.challenge.cleared = cleared // clearedはそのまま
            this.params.challenge.continuation = 0
            this.params.challenge.done_at = done_at // done_atもそのまま

            this.$axios.put(url, this.params)
            .then((res) => {
                console.log("continuationが0になったよ");
                this.fetchContent()

                this.params.challenge.cleared = 0
                this.params.challenge.done_at = null
            })
            .catch((err) => {
                console.log("error.")
            })
        },
        start(id) {
            const url = `/api/v1/challenges/${id}`
            this.$axios.put(url, this.params)
                .then((res) => {
                    this.getMyChallenges() // challengesを再取得  
                })
                .catch((err) => {
                    console.log("error.")
                })  
        },
        pushDone(id, cleared, continuation, done_at, idx) {
            const url = `/api/v1/challenges/${id}`
            this.params.challenge.cleared = cleared + 1
            this.params.challenge.done_at = new Date
            done_at = new Date(done_at); // jsonのdateをjsのDateに変換

            if (done_at < this.yesterday) { //Doneが押された時の昨日の日付とdone_atを比較
                continuation = 0 //最後のDoneが昨日より前と判定されたら、continuationを一旦0にする
            }

            this.params.challenge.continuation = continuation + 1

            

            console.log(this.params)
            this.$axios.put(url, this.params)
                .then((res) => {
                    console.log("yeah");
                    this.getMyChallenges() // challengesを再取得  
                })
                .catch((err) => {
                    console.log("error.")
                })  
        },

    }
}
</script>