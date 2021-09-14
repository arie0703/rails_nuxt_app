<template>
    <div>
        <v-btn @click="showEdit">
            Edit
        </v-btn>


        <v-dialog
        v-model="display"
        width="500"
        >
            <v-container>
                <v-form>
                    <v-text-field
                    v-model="edit_title"
                    label="title"
                    >
                    </v-text-field>
                    <v-text-field
                    v-model="edit_detail"
                    label="detail"
                    >
                    </v-text-field>
                    <v-text-field
                    v-model="edit_goal"
                    type="number"
                    label="goal"
                    max="100"
                    min="1"
                    >
                    </v-text-field>

                    <v-btn @click="update">
                        Update
                    </v-btn>
                </v-form>
            </v-container>
            

        </v-dialog>
    </div>
</template>

<script>
export default {
    props: {
        title: String,
        detail: String, 
        goal: Number,
    },
    // 親ビューから渡された値をそのままv-modelとして使うとcosoleで警告が出る
    // 子ビューで新しい変数を定義→そこにpropsの値格納→編集してparamsにセットしてput

    data: () => {
        return {
            display: false,
            card: {},
            edit_title: '',
            edit_detail: '',
            edit_goal: '',
        }
    },
    computed: { // propsで受け取った値はcomputed内部でreturnしなきゃいけない
        params() {
            return {
                card: {
                    title: this.edit_title,
                    detail: this.edit_detail,
                    goal: this.edit_goal,
                }
            }
        },
        setEditForm() {
            return this.edit_title = this.title, this.edit_detail = this.detail, this.edit_goal = this.goal
        },
    },
    methods: {
        showEdit() {
            this.setEditForm // モーダルが呼び出される時点でedit_titleなどのフォーム用変数にpropsの値代入
            this.display = true
        },
        update() {
            const url = `/api/v1/cards/${this.$route.params.id}`
            this.$axios.put(url, this.params)
                .then((res) => {
                    this.updateData()
                    this.display = false
                })
                .catch((err) => {
                    console.log("error.")
                })
        },
        updateData() {
            this.$emit('updateData');
            // 親コンポーネント（_id）のfetchContentを発火させる
        },
    }
}
</script>