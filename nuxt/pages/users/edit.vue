<template>
    <v-container>
        <v-btn @click="showEdit">
            Edit
        </v-btn>


        <v-dialog
        v-model="display"
        width="500"
        >
            <v-card>
                <v-container>
                    <v-card-title>ユーザー情報を編集</v-card-title>
                    <v-form>
                        <v-text-field
                        v-model="edit_email"
                        prepend-icon="mdi-email"
                        label="メールアドレス"
                        >
                        </v-text-field>
                        <v-text-field
                        v-model="edit_name"
                        prepend-icon="mdi-account"
                        label="ユーザー名"
                        >
                        </v-text-field>

                        <v-file-input
                        truncate-length="15"
                        @change="setImage"
                        label="プロフィール画像"
                        accept="image/png, image/jpeg, image/bmp"
                        >
                        </v-file-input>
                        <v-btn @click="update">
                            Update
                        </v-btn>
                    </v-form>
                </v-container>
            </v-card>
            

        </v-dialog>
    </v-container>
</template>

<script>
export default {
    name: "UserEdit", // card配下のedit.vueとファイル名が重複しているので、呼び出し時にエラーが出るのを防ぐ
    props: {
        email: String,
        name: String, 
    },
    // 親ビューから渡された値をそのままv-modelとして使うとcosoleで警告が出る
    // 子ビューで新しい変数を定義→そこにpropsの値格納→編集してparamsにセットしてput

    data: () => {
        return {
            display: false,
            card: {},
            edit_email: '',
            edit_name: '',
            image: null,
        }
    },
    computed: { // propsで受け取った値はcomputed内部でreturnしなきゃいけない
        params() {
            return {
                user: {
                    email: this.edit_email,
                    name: this.edit_name,
                },
            }
        },
        setEditForm() {
            return  this.edit_email = this.email, this.edit_name = this.name
        },
    },
    methods: {
        showEdit() {
            this.setEditForm // モーダルが呼び出される時点でedit_titleなどのフォーム用変数にpropsの値代入
            this.display = true
        },
        setImage(e) {
            console.log(e)
            this.image = e;
        },
        update() {
            const url = `/api/v1/auth/user/${this.$route.params.id}`
            this.$axios.put(url, this.params.user)
                .then((res) => {
                    if (this.image) { // imageがnullの時（アップロードされてない時）は画像更新処理しない
                        this.uploadImage()
                    }
                    this.updateData() //親ビューのデータ更新メソッドを発火
                    this.display = false
                })
                .catch((err) => {
                    console.log("error.")
                })
        },
        uploadImage() {
            const url = `/api/v1/auth/user_img/${this.$route.params.id}`
            const formData = new FormData();
            formData.append("image", this.image);
            const config = {
                headers: {
                    "content-type": "multipart/form-data",
                }
            };
            this.$axios.put(url, formData, config)
                .then((res) => {
                    console.log(config)
                    this.updateData() //親ビューのデータ更新メソッドを発火
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