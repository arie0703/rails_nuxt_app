<template>
    <v-container>
        <p>{{user.name}}さんのマイページ</p>
        <p>{{user.email}}</p>
    </v-container>
</template>

<script>
export default {
    auth: false,
    data: () => {
        return {
        user: {},
        }
    },
    mounted() {
        this.fetchContent()
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
    }
}
</script>