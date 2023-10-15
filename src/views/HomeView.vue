<template>
  <div style="margin-top: 10vh;justify-content: center;">
    <PongGame/>
  </div>
</template>

<script>
import PongGame from '@/components/PongGame.vue';

export default {
  name: 'HomeView',
  components: {
    PongGame
  }
}
</script>
