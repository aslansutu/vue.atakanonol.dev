<template>
  <NavigationBar/>
  <UnderConstruction/>
</template>

<script>
import NavigationBar from './components/NavigationBar.vue';
import UnderConstruction from './components/UnderConstruction.vue';

export default {
  name: 'App',
  components: {
    NavigationBar,
    UnderConstruction
}
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
}

body {
  background-color: #fff;
}
</style>
