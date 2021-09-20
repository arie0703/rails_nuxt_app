<template>
  <div v-if="loading">
    
    <div class="top-container">
      <h2>みんなのスタンプカード</h2>
      <p>{{ cards.length }}件の投稿</p>
      <New @updateData="fetchContents"></New>
      <v-btn v-if="!$auth.loggedIn" v-on:click="$router.push('/users/sign_in')">Sign In</v-btn>
    </div>
    <div class="card-container">
      <v-card
        v-for="card in cards"
        :key="card.id"
        class="stamp-card"
      >
        <v-container @click="toShow(card.id)">
          
          
          <v-card-text>
            <strong>{{ card.title }}</strong>
          </v-card-text>
          <v-container class="stamp-container">
            <v-row v-for="r in 2" :key="r">
              <div v-for="n in 5" :key="n" class="stamp-area"></div>
            </v-row>
          </v-container>
          

          <!-- <v-icon v-if="$auth.user.id == card.user_id" :right="true" v-on:click="showAlert = true; card_id = card.id">mdi-minus</v-icon> -->
          
          
        </v-container>
      </v-card>
    </div>


    <!-- <v-dialog
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
    </v-dialog> -->


    
  </div>
</template>

<style scoped>

.top-container {
  padding-left: 20px;
}
.card-container {
  display: flex;
  width: 100%;
  flex-wrap: wrap;
}
.stamp-card {
  margin: 20px;
  width: 270px;
}

.stamp-card:hover {
  background: rgba(100,100,100,0.4);
  transition: 0.4s;
  cursor: pointer;
}

.stamp-container {
  background-color: rgba(40,40,40,0.8);
  padding: 8px;
  width: 226px;
  border-radius: 5px;
}
.stamp-area {
  background-color: rgba(60,60,60,0.8);
  width: 40px;
  height: 40px;
  margin: 1px;
}

.row {
  margin: 0;
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
      card_id: 0,
    }
  },

  mounted() {
    this.fetchContents()
    this.getCurrentUser()
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
    },
  }
}
</script>