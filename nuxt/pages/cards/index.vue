<template>
  <div class="container py-5">
    <b-card
      v-for="card in cards"
      :key="card.id"
    >
      <b-card-text>
        {{ card.detail }}
      </b-card-text>
    </b-card>
  </div>
</template>

<script>
export default {
  data: () => {
    return {
      cards: [],
    }
  },

  mounted() {
    this.fetchContents()
  },

  methods: {
    fetchContents() {
      const url = "/api/v1/cards"
      this.$axios.get(url)
        .then((res) => {
          console.log(res)
          this.cards = res.data.posts
          console.log(cards)
        })
        .catch(() => {
          console.log("error.")
        })
    },
  }
}
</script>