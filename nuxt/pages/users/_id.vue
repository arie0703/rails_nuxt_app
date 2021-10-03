<template>
    <v-container>
        <div class="user-info-top">
            <img v-if="user_image" class="user-image" :src="user_image">
            <img v-if="!user_image" class="user-image" src="/noicon.jpeg">
            <p>{{user.name}}さんのマイページ</p>
        </div>
        <p>{{user.email}}</p>
        
        <UserEdit v-if="$auth.user.id == user.id" @updateData="fetchContent" :email.sync="user.email" :name.sync="user.name"></UserEdit>
        

        <strong>マイチャレンジ</strong>
        <v-container class="challenge-menu">
            <v-row>
                <span class="content on" id="content-1" @click="clickMenu(1)">着手中</span>
                <span class="content" id="content-2" @click="clickMenu(2)">達成済み</span>
            </v-row>
        </v-container>
        <v-row>
            <v-card
            v-for="challenge in challenges"
            :key="challenge.id"
            width="275"
            class="stamp-card"
            >
                <CardView :challenge="challenge" :yesterday="yesterday" :today="today" @updateData="getMyChallenges"></CardView>
            </v-card>
        </v-row>
    </v-container>
</template>

<style scoped>
.v-card {
    margin: 10px;
}


.user-info-top {
    display: flex;
    line-height: 50px;
}

.user-image {
    width: 50px;
    height: 50px;
    margin-right: 10px;
    border-radius: 50%;
    object-fit: cover;
}

.challenge-menu {
    padding: 25px 10px;
}

.challenge-menu .content {
    margin-right: 10px;
}

.challenge-menu .content:hover {
    cursor: pointer;
    color: orange;
    transition: 0.4s;
}

.on {
    color: orange;
    border-bottom: solid 1px;
}
</style>
<script>
import UserEdit from './edit.vue'
import CardView from '../challenges/cardview.vue'
export default {
    auth: false,
    components: {
        UserEdit,
        CardView,
    },
    data: () => {
        return {
            user: {},
            user_image: "",
            challenges: [],
            continuation: 0,
            cleared: 0,
            yesterday: new Date(),
            today: new Date(),
            deleteId: 0,
            selectedMenu: 1,
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
    methods: {
        fetchContent() {
            const url = `/api/v1/auth/user/${this.$route.params.id}`
            this.$axios.get(url)
            .then((res) => {
                this.user = res.data
                // console.log(res.data)
                console.log(this.user.image)
                this.user_image = this.user.image.url
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
            let url = `/api/v1/challenges?user_id=${this.$route.params.id}`
            if (this.selectedMenu == 2) {
                url = `/api/v1/challenges_done?user_id=${this.$route.params.id}`
            }
            console.log(url)
            
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
        clickMenu(n) {
            var c1 = document.getElementById("content-1");
            var c2 = document.getElementById("content-2");

            if (this.selectedMenu != n) {
                if(n === 1) {
                    c1.classList.add("on")
                    c2.classList.remove("on")
                    this.selectedMenu = 1;
                } else if (n === 2) {
                    c2.classList.add("on")
                    c1.classList.remove("on")
                    this.selectedMenu = 2;
                }
            }
            

            this.getMyChallenges()
        }


    }
}
</script>