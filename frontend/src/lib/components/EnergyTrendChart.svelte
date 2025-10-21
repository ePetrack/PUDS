<script lang="ts">
	import { onMount } from 'svelte';
	import * as echarts from 'echarts';

	let chartContainer: HTMLDivElement;
	let chart: echarts.ECharts;

	onMount(async () => {
		// Fetch trend data
		const response = await fetch('/api/dashboard/energy-trends?days=30');
		const data = await response.json();

		// Initialize ECharts
		chart = echarts.init(chartContainer);

		const option = {
			tooltip: {
				trigger: 'axis',
				axisPointer: {
					type: 'cross'
				}
			},
			legend: {
				data: ['Electricity Consumption', 'Baseline'],
				top: 0
			},
			grid: {
				left: '3%',
				right: '4%',
				bottom: '3%',
				containLabel: true
			},
			xAxis: {
				type: 'time',
				boundaryGap: false
			},
			yAxis: {
				type: 'value',
				name: 'Power (kW)',
				axisLabel: {
					formatter: '{value}'
				}
			},
			series: [
				{
					name: 'Electricity Consumption',
					type: 'line',
					smooth: true,
					data: data.electricity.map((d: any) => [d.timestamp, d.value]),
					itemStyle: {
						color: '#2563eb'
					},
					areaStyle: {
						color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
							{ offset: 0, color: 'rgba(37, 99, 235, 0.3)' },
							{ offset: 1, color: 'rgba(37, 99, 235, 0.05)' }
						])
					}
				},
				{
					name: 'Baseline',
					type: 'line',
					data: data.electricity.map((d: any) => [d.timestamp, data.baseline.value]),
					itemStyle: {
						color: '#f59e0b'
					},
					lineStyle: {
						type: 'dashed'
					}
				}
			]
		};

		chart.setOption(option);

		// Handle resize
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
