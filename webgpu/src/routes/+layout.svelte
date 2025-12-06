    <script lang="ts"> import type { Snippet } from "svelte"; import favicon from "$lib/assets/favicon.svg"; let { children }: { children: Snippet<[]> } = $props(); </script>
<!--<script lang="ts"> import type { Snippet } from "svelte"; import favicon from "$lib/assets/favicon.svg"; let { children }: { children: Snippet<[]> } = $props(); </script>-->
    <svelte:head> <link rel="icon" href={favicon} /> </svelte:head>
<!--<svelte:head> <link rel="icon" href={favicon} /> </svelte:head>-->
    {@render children()}
<!--{@render children()}-->
    <svelte:options runes={true}></svelte:options>
<!--<svelte:options runes={true}></svelte:options>-->
