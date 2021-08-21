<template>
  <div class="container py-5">
    <v-card>
      <v-card-text>
        {{ card.title }}
      </v-card-text>
      <v-card-text>
        {{ card.detail }}
      </v-card-text>
      <v-card-text>
        {{ card.goal }}
      </v-card-text>
      <v-btn
        size="sm"
        @click="toTop()"
      >
        Topへ
      </v-btn>
    </v-card>
  </div>
</template>

<script>
export default {

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