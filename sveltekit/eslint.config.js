import globals from 'globals';
import js from '@eslint/js';
import tseslint from 'typescript-eslint';

// Svelte modules
import svelteEslintParser from 'svelte-eslint-parser';
import eslintPluginSvelte from 'eslint-plugin-svelte';

// Prettier modules
import eslintConfigPrettier from 'eslint-config-prettier';

export default tseslint.config(
  eslintConfigPrettier,

  {
    ignores: ['.svelte-kit/']
  },

  {
    files: ['src/**/*.svelte', 'src/**/*.ts'],
    extends: [
      ...tseslint.configs.recommended,
      eslintPluginSvelte.configs['flat/recommended'],
      eslintPluginSvelte.configs['flat/prettier']
    ],
    languageOptions: {
      globals: { ...globals.browser, ...globals.node },
      parser: svelteEslintParser,
      parserOptions: {
        parser: tseslint.parser,
        project: 'tsconfig.json',
        extraFileExtensions: ['.svelte']
      }
    }
  },

  {
    files: ['**/*.cjs'],
    ignores: ['src/**'],
    languageOptions: {
      parserOptions: {
        sourceType: 'commonjs'
      }
    }
  },

  {
    files: ['**/*.js', '**/*.cjs'],
    ignores: ['src/**'],
    extends: [js.configs.recommended],
    languageOptions: {
      globals: globals.node,
      parser: js.parser
    }
  },

  {
    files: ['**/*.ts'],
    ignores: ['src/**'],
    extends: [...tseslint.configs.recommended],
    languageOptions: {
      globals: globals.node,
      parser: tseslint.parser,
      parserOptions: {
        project: 'tsconfig.json'
      }
    }
  }
);
