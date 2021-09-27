<template>
  <div class="container py-5" v-if="display">
    <v-row>
    <v-card width="280">
      <v-card-text>
        <strong>{{ card.title }}</strong>
      </v-card-text>
      
      <Stamps :cleared="0" :goal="card.goal"></Stamps>

      <v-card-text>
        目標日数: {{ card.goal }}（目安）
      </v-card-text>
      
    </v-card>

    <div class="side">
      <v-row>
        <v-btn
          size="sm"
          @click="toTop()"
        >
          一覧に戻る
        </v-btn>
        <CardEdit v-if="$auth.user.id == card.user_id" @updateData="fetchContent" :title.sync="card.title" :detail.sync="card.detail" :goal.sync="card.goal"></CardEdit>
        <v-btn v-if="$auth.user.id == card.user_id" v-on:click="showAlert = true">削除</v-btn>
        <v-btn
          size="sm"
          @click="isShowAddForm = true"
          v-if="$auth.loggedIn"
        >
          マイチャレンジに追加
        </v-btn>

        <v-dialog
        width="500"
        v-model="isShowAddForm"
        >
          <v-container>
            <p>マイチャレンジに追加する</p>
            <v-form>
              <v-card-text>目標日数（目安は{{ card.goal }}日）</v-card-text>
              <v-text-field v-model="goal" label="card.goal" type="number" max="100" min="1"></v-text-field>
            </v-form>
            <v-btn @click="addToChallenge">追加</v-btn>
          </v-container>
        
        </v-dialog>

        <v-dialog width="500" v-model="isShowMessage">
          <v-container>
            <p>マイチャレンジに追加されました！</p>
            <v-btn @click="isShowMessage=false">OK</v-btn>
          </v-container>
        </v-dialog>


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
          </v-alert>
          <v-btn @click="destroy()">削除</v-btn>
          <v-btn v-on:click="showAlert=false">キャンセル</v-btn>
        </v-card-text>
        </v-dialog>
      </v-row>

      <v-container>
        <p>投稿者: 
          <span class="user-link" @click="$router.push((`/users/${user.id}`))">{{user.name}}</span>
        </p>

        <p>
          {{ card.detail }}
        </p>
      </v-container>
    </div>
    </v-row>
  </div>
</template>

<style scoped>
/* Stampsのcontainerのstyleはこっちで調節可 */
.stamp-container { 
  background-color: rgba(40,40,40,0.8);
  padding: 22px;
  width: 260px;
  height: auto;
  border-radius: 5px;
  margin: 10px;
}

.side {
  margin-left: 20px;
}

.row {
  margin: 0;
}

.user-link {
  cursor: pointer;
}

.user-link:hover {
  color: orange;
  transition: 0.4s;
}



</style>

<style>
.side .v-btn {
  margin: 5px;
}
</style>

<script>
import CardEdit from './edit.vue'
import Stamps from '../challenges/stamps.vue'
export default {
  auth: false,
  components: {
    CardEdit,
    Stamps
  },
  data: () => {
    return {
      card: {},
      user: {}, // 投稿者の情報
      isShowAddForm: false,
      isShowMessage: false,
      goal: 0,
      row: 0,
      reminder: 0,
      showAlert: false,
      display: false,
    }
  },
  computed: {
    params() {
      return {
        challenge: { // 保存する内容
          title: this.card.title,
          detail: this.card.detail,
          goal: this.goal,
          cleared: 0,
          continuation: 0,
          is_started: false,
          is_done: false,
          user_id: this.$auth.user.id,
        }
      }
    },
  },

  mounted() {
    this.fetchContent()
  },
  methods: {
    fetchContent() {
        const url = `/api/v1/cards/${this.$route.params.id}`
        this.$axios.get(url)
        .then((res) => {
            this.card = res.data
            this.goal = this.card.goal
            // this.setStampArea(this.goal)
            console.log(res.data)
            this.getUserInfo()
        })
        .catch(() => {
            this.toTop()
        })
    },
    getUserInfo() {
      const url = `/api/v1/auth/user/${this.card.user_id}`
      this.$axios.get(url)
      .then((res) => {
            this.user = res.data
            this.display = true; // card, userのデータを受け取ってからビューを表示させないとエラーになる
        })
        .catch(() => {
            this.toTop()
        })
      
    },
    toTop() {
        this.$router.push(`/cards`)
    },
    addToChallenge() {
      const url = "/api/v1/challenges"
      console.log(this.goal, this.params.goal)
      this.$axios.post(url, this.params)
        .then((res) => {
          // 保存成功時
          console.log(res)
          this.isShowAddForm = false
          this.isShowMessage = true;
        })
        .catch((err) => {
          // 保存失敗時
        })
    },
    destroy() {
      const url = `/api/v1/cards/${this.$route.params.id}`
      console.log(url)

      this.$axios.delete(url)
        .then(() => {
          this.showAlert = false;
          this.$router.push('/cards')
        })
        .catch((err) => {
          const message = err.response.data
          this.$bvToast.toast(message, {
            title: 'エラー',
            variant: 'danger'
          })
        })
    },

  }
}
</script>