<template>
    <v-container>
        <p>{{user.name}}さんのマイページ</p>
        <p>{{user.email}}</p>

        <strong>マイチャレンジ</strong>
        <v-card
        v-for="challenge in challenges"
        :key="challenge.id"
        >
            <v-container>
                <v-card-text>{{ challenge.title }}</v-card-text>
            </v-container>
        </v-card>
    </v-container>
</template>

<script>
export default {
    auth: false,
    data: () => {
        return {
            user: {},
            challenges: []
        }
    },
    mounted() {
        this.fetchContent()
        this.getMyChallenges()
    },
    methods: {
        fetchContent() {
            const url = `/api/v1/auth/user/${this.$route.params.id}`
            this.$axios.get(url)
            .then((res) => {
                this.user = res.data
                console.log(res.data)
            })
            .catch(() => {
                console.log("error");
            })
        },
        getMyChallenges() {
            const url = `/api/v1/challenges?user_id=${this.$auth.user.id}`
            this.$axios.get(url)
                .then((res) => {
                this.challenges = res.data
                console.log(res);
                this.loading = true
                })
                .catch((err) => {
                console.log("error.")
                })
        },
    }
}
</script>