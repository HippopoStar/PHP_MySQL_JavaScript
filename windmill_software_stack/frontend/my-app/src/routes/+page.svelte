<script lang="ts">
	import PushButton from './PushButton.svelte';

	let startButtonEnabled = $state(true)
	let stopButtonEnabled = $state(false)
	function buttonClickHandler() {
		startButtonEnabled = !startButtonEnabled;
		stopButtonEnabled = !stopButtonEnabled;
	}
</script>

<h1>Welcome to SvelteKit</h1>
<p>Visit <a href="https://svelte.dev/docs/kit">svelte.dev/docs/kit</a> to read the documentation</p>

<PushButton
	text={"Start"}
	fontColor={"green"}
	bgColor={"lightgreen"}
	enabled={startButtonEnabled}
	onclick={buttonClickHandler}
/>
<PushButton
	text={"Stop"}
	fontColor={"darkred"}
	bgColor={"red"}
	enabled={stopButtonEnabled}
	onclick={buttonClickHandler}
/>
