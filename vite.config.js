import { defineConfig } from "vite";
import crystal from "vite-plugin-crystal";
import tailwindcss from "@tailwindcss/vite";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
  // disable automatic clear screen
  clearScreen: false,
  plugins: [
    crystal({
      appPort: 8080,
    }),
    tailwindcss(),
    vue(),
  ],
});
