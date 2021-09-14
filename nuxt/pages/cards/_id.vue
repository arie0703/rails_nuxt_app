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
    }
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
  }
}
</script>