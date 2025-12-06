    import adapter from "@sveltejs/adapter-auto";
//  import adapter from "@sveltejs/adapter-auto";
    import { vitePreprocess } from "@sveltejs/vite-plugin-svelte";
//  import { vitePreprocess } from "@sveltejs/vite-plugin-svelte";
    /** @type {import("@sveltejs/kit").Config} */
//  /** @type {import("@sveltejs/kit").Config} */
    const config = {
//  const config = {
        // Consult https://svelte.dev/docs/kit/integrations
//      // Consult https://svelte.dev/docs/kit/integrations
        // for more information about preprocessors
//      // for more information about preprocessors
        preprocess: vitePreprocess(),
//      preprocess: vitePreprocess(),
        kit: {
//      kit: {
            // adapter-auto only supports some environments, see https://svelte.dev/docs/kit/adapter-auto for a list.
//          // adapter-auto only supports some environments, see https://svelte.dev/docs/kit/adapter-auto for a list.
            // If your environment is not supported, or you settled on a specific environment, switch out the adapter.
//          // If your environment is not supported, or you settled on a specific environment, switch out the adapter.
            // See https://svelte.dev/docs/kit/adapters for more information about adapters.
//          // See https://svelte.dev/docs/kit/adapters for more information about adapters.
            adapter: adapter()
//          adapter: adapter()
        }
//      }
    };
//  };
    export default config;
//  export default config;
