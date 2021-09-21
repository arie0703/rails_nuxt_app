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
            <v-row>
              <div v-for="n in 5" :key="n" class="stamp-area"></div>
            </v-row>

            <v-row>
              <div v-for="n in 4" :key="n" class="stamp-area"></div>
              <div class="stamp-area">
                <div class="last-stamp">{{ card.goal }}</div>
              </div>
            </v-row>
          </v-container>
          
          
        </v-container>
      </v-card>
    </div>


    
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

.last-stamp {
  width: 35px;
  height: 35px;
  border-radius: 50%;
  background: darkcyan;
  margin: 2.5px;
  justify-content: center;
  line-height: 35px;
  text-align: center;
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