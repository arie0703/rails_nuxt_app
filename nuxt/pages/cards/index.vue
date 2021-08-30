<template>
  <div v-if="loading">
    <p>{{ cards.length }}</p>

    <div class="card-container">
      <v-card
        v-for="card in cards"
        :key="card.id"
        class="stamp-card"
      >
        <v-container>
          <v-row>
            <v-col @click="toShow(card.id)">
              <v-card-title>{{ card.title }}</v-card-title>
              <v-card-text>{{ card.detail }}</v-card-text>
              <v-card-text>{{ card.start_date }}</v-card-text>
            </v-col>

            <v-icon :right="true" v-on:click="showAlert = true; card_id = card.id">mdi-minus</v-icon>
          </v-row>
          
        </v-container>
      </v-card>
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
      </v-alert>
      <v-btn @click="destroy(card_id)">削除</v-btn>
      <v-btn v-on:click="showAlert=false">キャンセル</v-btn>
    </v-card-text>
    </v-dialog>


    <New @updateData="fetchContents"></New>
    
    <v-btn v-if="!$auth.loggedIn" v-on:click="$router.push('/users/sign_in')">Sign In</v-btn>
  </div>
</template>

<style scoped>

.card-container {
  display: flex;
  width: 100%;
  flex-wrap: wrap;
}
.stamp-card {
  margin: 20px;
  width: 330px;
}
</style>

<script>
import New from './new.vue'
export default {
  
  auth: false,
  components: {
    New
  },
  data: () => {
    return {
      cards: [],
      dialog: false, // trueになったらモーダルオープンする
      loading: false,
      showAlert: false,
      card_id: 0
    }
  },

  mounted() {
    this.fetchContents()
    this.getCurrentUser()
  },



  computed: {
    disabled() {
      return this.detail.length === 0
    },

    params() {
      return {
        card: { // 保存する内容
          title: this.title,
          detail: this.detail,
          goal: this.goal,
          cleared: 0,
          continuation: 0,
          is_started: false,
          is_done: false,
          start_date: this.start_date,
          end_date: this.end_date,
        }
      }
    }
  },

  methods: {
    fetchContents() {
      const url = "/api/v1/cards"
      this.$axios.get(url)
        .then((res) => {
          this.cards = res.data.cards
          console.log(res.data.cards);
          this.loading = true
        })
        .catch((err) => {
          console.log("error.")
        })
    },
    save() {
      const url = "/api/v1/cards"
      this.$axios.post(url, this.params)
        .then((res) => {
          // 保存成功時
          console.log(res)
          // 保存時にデータを更新する
          this.fetchContents()

          this.dialog = false // モーダル閉じる
          this.title = ""
          this.goal = 0
          this.detail = ""
        })
        .catch((err) => {
          // 保存失敗時
        })
    },
    destroy(id) {
      const url = `/api/v1/cards/${id}`
      console.log(url)

      this.$axios.delete(url)
        .then(() => {
          this.fetchContents()
          this.showAlert = false;
        })
        .catch((err) => {
          const message = err.response.data
          this.$bvToast.toast(message, {
            title: 'エラー',
            variant: 'danger'
          })
        })
    },
    toShow(id) {
      this.$router.push(`/cards/${id}`)
    },
    logout() {
      console.log("aaa")
    },
    getCurrentUser() {
      console.log(this.$auth.user)
    }
  }
}
</script>