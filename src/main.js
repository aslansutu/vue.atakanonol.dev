import { createApp } from 'vue'
import App from './App.vue'

import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { faBars } from '@fortawesome/free-solid-svg-icons'
import router from './router'

library.add(faBars)

createApp(App).use(router)
.component('font-awesome-icon', FontAwesomeIcon)
.mount('#app')
