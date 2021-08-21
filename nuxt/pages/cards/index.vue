<template>
  <div class="container py-5">
    <v-card
      v-for="card in cards"
      :key="card.id"
      @click="toShow(card.id)"
    >
      <v-card-text>
        {{ card.title }}
      </v-card-text>
    </v-card>


    <v-dialog
      v-model="dialog"
      width="500"
    >
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          color="primary lighten-2"
          dark
          v-bind="attrs"
          v-on="on"
        >
          Dialog Open
        </v-btn>
      </template>
      <v-card-text>
      <v-form>
  
        <v-text-field
          v-model="title"
          label="title"
        >
        </v-text-field>
        <v-text-field
          v-model="detail"
          label="detail"
        >
        </v-text-field>
        <v-text-field
          v-model="goal"
          type="number"
          label="goal"
          max="100"
          min="1"
        >
        </v-text-field>
        <v-btn
          class="mt-3"
          variant="primary"
          @click="save()"
        >
          保存
        </v-btn>
      </v-form>
      </v-card-text>
    </v-dialog>
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
          is_done: false
        }
      }
    }
  },

  methods: {
    fetchContents() {
      const url = "/api/v1/cards"
      this.$axios.get(url)
        .then((res) => {
          console.log(res)
          this.cards = res.data.cards
          console.log(cards)
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
        })
        .catch((err) => {
          // 保存失敗時
        })
    },
    toShow(id) {
      this.$router.push(`/cards/${id}`)
    }
  }
}
</script>