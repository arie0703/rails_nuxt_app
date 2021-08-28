<template>
  <v-row justify="center" align="center">
    <v-col cols="12" sm="8" md="6">
      <v-card>
        <v-col class="logo py-4 d-flex justify-center">
          <NuxtLogo />
          <VuetifyLogo />
        </v-col>
        <v-col>
          <v-card-title class="headline">
            Welcome to Stamper App!
          </v-card-title>
          <v-card-text>
            <p>Stamperは目標に向けて継続する人をサポートするアプリです</p>
          </v-card-text>
        </v-col>
      </v-card>
    </v-col>
  </v-row>
</template>

<script>
import Logo from '~/components/NuxtLogo.vue'
import VuetifyLogo from '~/components/VuetifyLogo.vue'

export default {
  auth: false,
  components: {
    Logo,
    VuetifyLogo
  },
}
</script>
