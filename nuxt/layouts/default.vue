<template>
  <v-app dark>
    <v-navigation-drawer
      v-model="drawer"
      :mini-variant="miniVariant"
      app
    >
      <v-list>
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
    </v-app-bar>
    <v-main>
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
</style>

<script>
export default {
  data () {
    return {
      drawer: false,
      items: [
        {
          icon: 'mdi-apps',
          title: 'Welcome',
          to: '/'
        },
        {
          icon: 'mdi-chart-bubble',
          title: 'Inspire',
          to: '/inspire'
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
  }
}
</script>
