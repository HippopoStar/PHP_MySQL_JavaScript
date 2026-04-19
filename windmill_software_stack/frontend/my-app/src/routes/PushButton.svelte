<!--
	/*
	** $props() - Basic Svelte / Props / Declaring props
	** aria-current - Basic Svelte / Logic / Each blocks
	** BigRedButton - Basic Svelte / Events / Spreading events
	** button:disabled - Basic Svelte / Bindings / Checkbox inputs
	** CSS custom property - Basic Svelte / Classes and styles / Component styles
	** named-color - Advanced Svelte / Reusing content / Implicit snippet props
	*/
-->
<script>
	let { text, fontColor = "gray", bgColor = "lightgray", enabled = false, onclick } = $props();
</script>

<button
	type="button"
	disabled={!enabled}
	style:--font-color={fontColor}
	style:--bg-color={bgColor}
	{onclick}
>
	{text}
</button>

<style>
	button {
		font-size: 1.4em;
		width: 6em;
		height: 6em;
		border-radius: 50%;
		background: var(--bg-color, lightgray);
		color: var(--font-color, gray);
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	button:disabled {
		background: lightgray;
		color: gray;
	}
</style>
