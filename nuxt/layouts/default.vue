<template>
  <v-app dark>
    <v-navigation-drawer
      v-model="drawer"
      :mini-variant="miniVariant"
      app
    >
      <v-list>

        <!-- リンクメニュー -->
        <v-list-item
          v-for="(item, i) in items"
          v-on:click="drawer = false"
          :key="i"
          :to="item.to"
          router
          exact
        >
          <v-list-item-action>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title v-text="item.title" />
          </v-list-item-content>
        </v-list-item>
        <!-- ログイン -->
        <v-list-item
          v-on:click="drawer = false"
          v-if="!$auth.loggedIn"
          to="/users/sign_in"
          router
          exact
        >
          <v-list-item-action>
            <v-icon>mdi-login</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>Sign in</v-list-item-title>
          </v-list-item-content>
        </v-list-item>

        <!-- ログアウト -->
        <v-list-item
          v-on:click="drawer = false; logout_dialog = true"
          v-if="$auth.loggedIn"
          router
          exact
        >
          <v-list-item-action>
            <v-icon>mdi-logout</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>Sign Out</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar
      app
    >
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" />

      <v-toolbar-title>
        <router-link to="/" class="nav-title" v-text="title"></router-link>
      </v-toolbar-title>
      <v-spacer />
      <div class="current-user-info" v-if="$auth.loggedIn" @click="toMypage($auth.user.id)">
        {{ $auth.user.email }}
      </div>
      <v-btn v-if="$auth.loggedIn" color="green" @click="logout_dialog=true">Sign out</v-btn>
      <v-btn v-if="!$auth.loggedIn" color="green" @click="$router.push('/users/sign_in')">Sign In</v-btn>
    </v-app-bar>
    <v-main>
      <v-dialog
        v-model="logout_dialog"
        width="500"
      >
        <v-card
          outlined
        >
          <v-container>
          <v-col>ログアウトしますか？</v-col>
          <v-btn color="blue" @click="$auth.logout(); logout_dialog=false">はい</v-btn>
          <v-btn color="orange" @click="logout_dialog = false">キャンセル</v-btn>
          </v-container>
        </v-card>
      </v-dialog>
      <v-container>
        <Nuxt />
      </v-container>
    </v-main>
    <!-- absolute=trueでfooter固定解除 -->
    <v-footer  
      :absolute="true" 
      app
    >
      <span>&copy; {{ new Date().getFullYear() }}</span>
    </v-footer>
  </v-app>
</template>

<style scoped>
.nav-title {
  color: #fff;
  text-decoration: none;
}

.nav-title:hover {
  color: #ffaa00;
  transition: 0.4s;
}

.current-user-info {
  margin-right: 15px;
}

.current-user-info:hover {
  color: #ffaa00;
  transition: 0.4s;
  cursor: pointer;
}
</style>

<script>
export default {
  data () {
    return {
      drawer: false,
      logout_dialog: false,
      items: [
        {
          icon: 'mdi-home',
          title: 'Home',
          to: '/'
        },
        {
          icon: 'mdi-card',
          title: 'Cards',
          to: '/cards'
        }
      ],
      miniVariant: false,
      right: true,
      title: 'Stamper(β)'
    }
  },
  mounted() {
    this.setUserInfo()
    console.log(this.$auth.user)
  },
  methods: {
    setUserInfo() {
      if (this.$auth.loggedIn && !this.$auth.user.id) { //リロードした際にstateのユーザー情報が空になるので、ローカルストレージに保存した情報を持ってくる
        var usrinfo = JSON.parse(localStorage.getItem("user_info")).auth.user;
        console.log(usrinfo)
        this.$auth.user = usrinfo
      }
    },
    toMypage(id) {
      this.$router.push(`/users/${id}`)
    }
  }
}
</script>
