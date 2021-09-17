<template>
    <v-container>
        <p>{{user.name}}さんのマイページ</p>
        <p>{{user.email}}</p>

        <strong>マイチャレンジ</strong>
        <v-card
        v-for="challenge in challenges"
        :key="challenge.id"
        width="500"
        >
            <v-container>
                <v-card-text>{{ challenge.title }}</v-card-text>
                <v-card-text>
                    達成日数: {{ challenge.cleared}} 
                    継続: {{ challenge.continuation }}

                </v-card-text>
                <v-card-text>{{ challenge.updated_at }}</v-card-text>
                <v-btn 
                @click="pushDone(challenge.id, challenge.cleared, challenge.continuation, challenge.updated_at)"
                v-if="!isDoneToday(challenge.updated_at)"
                >
                    Done
                </v-btn>

                <p v-if="isDoneToday(challenge.updated_at)">今日は達成済み</p>
            </v-container>
        </v-card>
    </v-container>
</template>

<style scoped>
.v-card {
    margin-top: 10px;
}
</style>
<script>
export default {
    auth: false,
    data: () => {
        return {
            user: {},
            challenges: [],
            continuation: 0,
            cleared: 0,
            start_of_yesterday: new Date(),
            start_of_today: new Date(),
        }
    },
    mounted() {
        this.fetchContent()
        this.getMyChallenges()
        this.setDate()
    },
    computed: {
        params() {
            return {
                challenge: {
                    cleared: this.cleared,
                    continuation: this.continuation,
                }
            }
        },
        isDoneToday: function() { // v-ifで引数を渡せるようにしておく
            self = this;
            return function (updated_at) {
                updated_at = new Date(updated_at)
                if (updated_at > this.start_of_today) {
                    return true
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
            this.start_of_yesterday.setDate(this.start_of_yesterday.getDate() - 1);
            this.start_of_yesterday.setHours(0, 0, 0, 0);
            this.start_of_today.setHours(0, 0, 0, 0);
        },
        getMyChallenges() {
            const url = `/api/v1/challenges?user_id=${this.$auth.user.id}`
            this.$axios.get(url)
                .then((res) => {
                this.challenges = res.data
                // console.log(res);
                this.loading = true
                })
                .catch((err) => {
                console.log("error.")
                })
        },
        pushDone(id, cleared, continuation, updated_at) {
            const url = `/api/v1/challenges/${id}`
            this.params.challenge.cleared = cleared + 1

            updated_at = new Date(updated_at); // jsonのtimestampをjsのDateに変換
            if (updated_at >= this.start_of_yesterday) { //updated_atが昨日の0時を超えていれば、継続判定
                this.params.challenge.continuation = continuation + 1
            }

            console.log(this.params)
            this.$axios.put(url, this.params)
                .then((res) => {
                    console.log("yeah");
                    this.fetchContent()
                })
                .catch((err) => {
                    console.log("error.")
                })
        },
    }
}
</script>