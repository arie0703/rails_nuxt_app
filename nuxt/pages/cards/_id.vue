<template>
  <div class="container py-5">
    <v-card>
      <v-card-text>
        <strong>{{ card.title }}</strong>
      </v-card-text>
      <v-card-text>
        {{ card.detail }}
      </v-card-text>
      <v-card-text>
        {{ card.goal }}
      </v-card-text>
      <v-container>
        <v-btn
          size="sm"
          @click="toTop()"
        >
          Topへ
        </v-btn>
        <Edit @updateData="fetchContent" :title.sync="card.title" :detail.sync="card.detail" :goal.sync="card.goal"></Edit>

        <v-btn
          size="sm"
          @click="addToChallenge()"
        >
          マイチャレンジに追加
        </v-btn>

        <v-dialog
        width="500"
        v-model="isShowMessage"
        >
          <v-container>
            <p>マイチャレンジに追加しました！</p>
            <v-btn @click="isShowMessage=false">OK</v-btn>
          </v-container>

        </v-dialog>
      </v-container>
    </v-card>
  </div>
</template>

<script>
import Edit from './edit.vue'
export default {
  auth: false,
  components: {
    Edit
  },
  data: () => {
    return {
      card: {},
      isShowMessage: false,
    }
  },
  computed: {
    params() {
      return {
        challenge: { // 保存する内容
          title: this.card.title,
          detail: this.card.detail,
          goal: this.card.goal,
          cleared: 0,
          continuation: 0,
          is_started: false,
          is_done: false,
          start_date: this.card.start_date,
          end_date: this.card.end_date,
          user_id: this.$auth.user.id
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
            console.log(res.data)
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
      console.log(this.card.title)
      console.log(this.params)
      this.$axios.post(url, this.params)
        .then((res) => {
          // 保存成功時
          console.log(res)
          this.isShowMessage = true;
        })
        .catch((err) => {
          // 保存失敗時
        })
    }
  }
}
</script>