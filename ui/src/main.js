import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'

// Vuetify
import 'vuetify/styles'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'

const myCustomDarkTheme = {
    dark: false,
    colors: {
      background: 'transparent',
      surface: '#000000',
      primary: '#6200EE',
      'primary-darken-1': '#3700B3',
      secondary: '#03DAC6',
      'secondary-darken-1': '#018786',
      error: '#B00020',
      info: '#2196F3',
      success: '#4CAF50',
      warning: '#FB8C00',
    },
  }

const vuetify = createVuetify({
    components,
    directives,
    theme: {
        defaultTheme: 'myCustomDarkTheme',
        themes: {
            myCustomDarkTheme,
          },
      }
  })

createApp(App).use(vuetify).mount('#app')
