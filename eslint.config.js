import js from "@eslint/js";
import globals from "globals";
import { defineConfig } from "eslint/config";

export default defineConfig([
  {
    files: ["**/*.{js,mjs,cjs}"],
    plugins: { js },
    extends: ["js/recommended"],
  },
  // Browser environment for public
  {
    files: ["public/**/*.{js,mjs,cjs}"],
    languageOptions: { globals: globals.browser },
  },
  // Node environment for everything else
  {
    files: ["**/*.{js,mjs,cjs}"],
    ignores: ["public/**/*.{js,mjs,cjs}"],
    languageOptions: { globals: globals.node },
  },
  {
    rules: {
      "no-unused-vars": "warn",
      "no-undef": "warn",
      quotes: ["error", "double", { allowTemplateLiterals: true }],
      // "no-console": "warn",
    },
  },
]);
