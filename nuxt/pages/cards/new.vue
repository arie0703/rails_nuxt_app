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
                <v-menu v-model="menu" max-width="290px" min-width="290px">
                    <template v-slot:activator="{ on }">
                    <v-text-field
                        slot="activator"
                        v-model="start_date"
                        label="開始日"
                        readonly
                        v-on="on"
                    />
                    </template>
                    <v-date-picker v-model="start_date" />
                </v-menu>
                <v-menu v-model="menu" max-width="290px" min-width="290px">
                    <!-- ポップアップを追加する要素にv-on="on" -->
                    <template v-slot:activator="{ on }">
                    <v-text-field
                        slot="activator"
                        v-model="end_date"
                        label="終了日"
                        readonly
                        v-on="on"
                    />
                    </template>
                    <v-date-picker v-model="end_date" />
                </v-menu>
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