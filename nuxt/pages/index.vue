<template>
  <v-row justify="center" align="center">
    <v-col cols="12" sm="8" md="6">
      <v-card>
        <v-col class="title-area py-4 d-flex justify-center">
          <div class="square-container">
            <div class="square">S</div>
            <div class="square">t</div>
            <div class="square">a</div>
            <div class="square">m</div>
            <div class="square">p</div>
            <div class="square">e</div>
            <div class="square">r</div>
          </div>

        </v-col>
        <v-col>
          <v-card-title class="headline">
            Welcome to Stamper App!
          </v-card-title>
          <v-card-text>
            <p>Stamperは目標に向けて継続する人をサポートするアプリです</p>
          </v-card-text>


          <v-card-title class="headline">
            What can I do using Stamper App?
          </v-card-title>
          <v-card-text>
            <p>スタンプカードを作成し、毎日の挑戦を記録することができます</p>
          </v-card-text>

          <v-row>
            <v-card width="280" class="card-example">
              <v-card-text>
                <strong>10日間ジョギングする！</strong>
              </v-card-text>
              <Stamps :cleared="2" :goal="10"></Stamps>
              
            </v-card>
            <v-col>
              <v-card-text>スタンプで日々の達成を可視化！</v-card-text>
              <v-card-text>これなら毎日頑張れます！</v-card-text>
            </v-col>
          </v-row>

          <v-card-title class="headline">
            Let's try Stamper!
          </v-card-title>

          <v-row class="btn-container">
            <v-btn v-if="!$auth.loggedIn" color="green" v-on:click="$router.push('/users/sign_in')">ログイン</v-btn>
            <v-btn v-if="!$auth.loggedIn" color="blue" v-on:click="$router.push('/users/sign_up')">新規登録</v-btn>
            <v-btn v-if="$auth.loggedIn" color="green" v-on:click="$router.push(`/users/${$auth.user.id}`)">マイページへ</v-btn>
            <v-btn color="orange" v-on:click="$router.push('/cards')">スタンプカード一覧へ</v-btn>
          </v-row>
        </v-col>
      </v-card>
    </v-col>
  </v-row>
</template>

<style scoped>

.title-area {
  background-image: url('/background-img.jpeg');
  background-size: cover;
  height: 280px;
  position: relative;
}

.square-container {
  position: absolute;
  top: 38%;
}

.square {
  width: 60px;
  height: 60px;
  background: rgba(50,50,50,0.7);
  line-height: 60px;
  text-align: center;
  font-size: 33px;
  font-family: 'Bradley Hand';
  color: #ddd;
  display:inline-block;
}

.card-example {
  height: 200px;
  background-color: #222;
  margin: 10px;
}

.stamp-container { 
  background-color: rgba(40,40,40,0.8);
  padding: 22px;
  width: 260px;
  height: auto;
  border-radius: 5px;
  margin: 10px;
  height:115px;
}

.btn-container {
  padding: 10px;
}
.btn-container button {
  margin: 5px;
}







@media only screen and (max-width: 767px) {
  .title-area {
    height: 180px;
  }

  .square {
    width: 30px;
    height: 30px;
    line-height: 30px;
    font-size: 18px;
  }
}





</style>

<script>
import Stamps from './challenges/stamps.vue'

export default {
  auth: false,
  components: {
    Stamps,
  },
}
</script>
