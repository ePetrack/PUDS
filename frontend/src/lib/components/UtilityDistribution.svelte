<script lang="ts">
	import { onMount } from 'svelte';
	import * as echarts from 'echarts';

	export let data: any[];

	let chartContainer: HTMLDivElement;
	let chart: echarts.ECharts;

	onMount(() => {
		chart = echarts.init(chartContainer);

		const option = {
			tooltip: {
				trigger: 'item',
				formatter: '{b}: ${c} ({d}%)'
			},
			legend: {
				orient: 'vertical',
				right: 10,
				top: 'center'
			},
			series: [
				{
					name: 'Utility Costs',
					type: 'pie',
					radius: ['40%', '70%'],
					avoidLabelOverlap: false,
					itemStyle: {
						borderRadius: 10,
						borderColor: '#fff',
						borderWidth: 2
					},
					label: {
						show: true,
						formatter: '{b}\n{d}%'
					},
					emphasis: {
						label: {
							show: true,
							fontSize: 16,
							fontWeight: 'bold'
						}
					},
					data: data.map((item) => ({
						name: item.type,
						value: item.cost
					})),
					color: ['#2563eb', '#10b981', '#f59e0b', '#ef4444']
				}
			]
		};

		chart.setOption(option);

		const resizeObserver = new ResizeObserver(() => {
			chart.resize();
		});
		resizeObserver.observe(chartContainer);

		return () => {
			resizeObserver.disconnect();
			chart.dispose();
		};
	});
</script>

<div class="chart-container" bind:this={chartContainer}></div>

<style>
	.chart-container {
		width: 100%;
		height: 350px;
		margin-top: var(--spacing-md);
	}
</style>
