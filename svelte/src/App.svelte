<script context="module" lang="ts">
  import { Router, createRouter } from '@roxi/routify';
  import routes from '../.routify/routes.default.js';

  export const router = createRouter({ routes });
</script>

<Router {router} />
