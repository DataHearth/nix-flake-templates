import js from '@eslint/js';
import globals from 'globals';
import tseslint from 'typescript-eslint';

// Svelte modules
import eslintPluginSvelte from 'eslint-plugin-svelte';
import svelteEslintParser from 'svelte-eslint-parser';
import svelteConfig from './svelte.config.js';

// Prettier modules
import eslintConfigPrettier from 'eslint-config-prettier';

export default tseslint.config(
  eslintConfigPrettier,

  {
    ignores: ['dist/'],
  },
  
  {
    files: ['src/**/*.svelte'],
    extends: [
      ...tseslint.configs.recommended,
      eslintPluginSvelte.configs['flat/recommended'],
      eslintPluginSvelte.configs['flat/prettier'],
    ],
    languageOptions: {
      globals: { ...globals.browser, ...globals.node },
      parser: svelteEslintParser,
      parserOptions: {
        parser: tseslint.parser,
        projectService: true,
        extraFileExtensions: ['.svelte'],
        svelteConfig,
      },
    },
  },

  {
    files: ['src/**/*.ts'],
    extends: [...tseslint.configs.recommended],
    languageOptions: {
      globals:  { ...globals.browser, ...globals.node },
      parser: tseslint.parser,
      parserOptions: {
        projectService: true,
      },
    },
  },

  {
    files: ['**/*.cjs'],
    ignores: ['src/**'],
    languageOptions: {
      parserOptions: {
        sourceType: 'commonjs',
      },
    },
  },

  {
    files: ['**/*.js', '**/*.cjs'],
    ignores: ['src/**'],
    extends: [js.configs.recommended],
    languageOptions: {
      globals: globals.node,
      parser: js.parser,
    },
  },

  {
    files: ['**/*.ts'],
    ignores: ['src/**'],
    extends: [...tseslint.configs.recommended],
    languageOptions: {
      globals: globals.node,
      parser: tseslint.parser,
      parserOptions: {
        projectService: true,
      },
    },
  }
);
