<template>
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
          v-if="$auth.loggedIn"
          @click="dialog = true"
        >
          New
        </v-btn>
      </template>
      <v-card v-if="dialog"> 
        <v-container>
            <v-form>
                <v-text-field
                v-model="title"
                label="チャレンジ名"
                >
                </v-text-field>
                <v-text-field
                v-model="detail"
                label="詳細・コメント"
                >
                </v-text-field>
                <v-text-field
                v-model="goal"
                type="number"
                label="目標日数（5〜30）"
                max="30"
                min="5"
                >
                </v-text-field>

                <v-btn
                class="mt-3"
                variant="primary"
                @click="save()"
                >
                保存
                </v-btn>
                <v-btn
                class="mt-3"
                variant="primary"
                v-on:click="dialog = false"
                >
                閉じる
                </v-btn>
            </v-form>
        </v-container>
      </v-card>
    </v-dialog>
</template>

<script>
export default {
  data: () => {
    return {
      dialog: false, // trueになったらモーダルオープンする
    }
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
          user_id: this.$auth.user.id
        }
      }
    },
  },
 
  methods: {
    save() {
      console.log(this.card)
      const url = "/api/v1/cards"
      this.$axios.post(url, this.params)
        .then((res) => {
          // 保存成功時
          console.log(res)
          // 保存時にデータを更新する
          this.updateData();

          this.dialog = false // モーダル閉じる
          this.title = ""
          this.goal = 0
          this.detail = ""
        })
        .catch((err) => {
          // 保存失敗時
        })
    },  
    updateData() {
      this.$emit('updateData');
      // 親コンポーネントのfetchContentsを発火させる
    },
  }
}
</script>