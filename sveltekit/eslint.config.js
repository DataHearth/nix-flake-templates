import globals from 'globals';
import js from '@eslint/js';
import tseslint from 'typescript-eslint';

// Svelte modules
import svelteEslintParser from 'svelte-eslint-parser';
import eslintPluginSvelte from 'eslint-plugin-svelte';

// Prettier modules
import eslintConfigPrettier from 'eslint-config-prettier';

export default tseslint.config(
  js.configs.recommended,
  eslintConfigPrettier,
  ...tseslint.configs.recommended,
  ...eslintPluginSvelte.configs['flat/recommended'],
  ...eslintPluginSvelte.configs['flat/prettier'],

  {
    ignores: ['build/', '.svelte-kit/', 'dist/', '*.config.js', '.direnv', '.env', '.env.*']
  },

  {
    languageOptions: {
      globals: { ...globals.browser, ...globals.node },
      parser: tseslint.parser,
      parserOptions: {
        project: ['tsconfig.json', 'tsconfig.node.json'],
        extraFileExtensions: ['.svelte']
      }
    }
  },

  {
    files: ['**/*.svelte', '*.svelte'],
    languageOptions: {
      parser: svelteEslintParser,
      parserOptions: {
        parser: tseslint.parser
      }
    }
  }
);
