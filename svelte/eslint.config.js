import pluginJs from '@eslint/js';
import tseslint from 'typescript-eslint';
import eslintPluginSvelte from 'eslint-plugin-svelte';
import eslintConfigPrettier from 'eslint-config-prettier';
import svelteParser from 'svelte-eslint-parser';
import globals from 'globals';

export default tseslint.config(
  {
    languageOptions: {
      globals: {
        ...globals.browser,
        ...globals.node
      },
      parserOptions: {
        project: 'tsconfig.json',
        extraFileExtensions: ['.svelte']
      },
      parser: tseslint.parser
    }
  },
  {
    languageOptions: {
      parserOptions: {
        parser: '@typescript-eslint/parser'
      },
      parser: svelteParser
    },
    files: ['**/*.svelte', '*.svelte']
  },
  {
    ignores: ['build/', '.svelte-kit/', 'dist/', '*.config.js', '.direnv', '.env', '.env.*']
  },
  ...tseslint.configs.recommended,
  ...eslintPluginSvelte.configs['flat/recommended'],
  ...eslintPluginSvelte.configs['flat/prettier'],
  pluginJs.configs.recommended,
  eslintConfigPrettier
);
