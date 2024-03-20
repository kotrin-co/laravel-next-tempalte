import vuetify from "~/utils/vuetify";

export default defineNuxtPlugin((app) => {
  app.vueApp.use(vuetify);
});
