import prettierPluginSvelte from 'prettier-plugin-svelte';
import * as prettierPluginTailwindcss from 'prettier-plugin-tailwindcss';

export default {
  trailingComma: 'es5',
  tabWidth: 2,
  semi: true,
  singleQuote: true,
  plugins: [prettierPluginSvelte, prettierPluginTailwindcss],
  overrides: [{ files: '*.svelte', options: { parser: 'svelte' } }],
  tailwindFunctions: ['clsx'],
};
