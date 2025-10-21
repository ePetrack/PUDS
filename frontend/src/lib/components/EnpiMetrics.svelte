<script lang="ts">
	import { onMount } from 'svelte';
	import * as echarts from 'echarts';

	let enpiData: any = null;
	let chartContainer: HTMLDivElement;
	let chart: echarts.ECharts;

	onMount(async () => {
		const response = await fetch('/api/dashboard/enpi-metrics');
		enpiData = await response.json();

		// Create gauge chart for primary EnPI
		chart = echarts.init(chartContainer);

		const primary = enpiData.primary_enpi;
		const percentage = ((primary.baseline_value - primary.value) / primary.baseline_value) * 100;

		const option = {
			title: {
				text: 'Primary EnPI Progress',
				left: 'center'
			},
			tooltip: {
				formatter: '{b} : {c}%'
			},
			series: [
				{
					name: 'EnPI Achievement',
					type: 'gauge',
					progress: {
						show: true,
						width: 18
					},
					axisLine: {
						lineStyle: {
							width: 18
						}
					},
					axisTick: {
						show: false
					},
					splitLine: {
						length: 15,
						lineStyle: {
							width: 2,
							color: '#999'
						}
					},
					axisLabel: {
						distance: 25,
						color: '#999',
						fontSize: 12
					},
					anchor: {
						show: true,
						showAbove: true,
						size: 25,
						itemStyle: {
							borderWidth: 10
						}
					},
					detail: {
						valueAnimation: true,
						formatter: '{value}% Improvement',
						color: 'inherit',
						fontSize: 16
					},
					data: [
						{
							value: percentage.toFixed(1),
							name: primary.name
						}
					],
					itemStyle: {
						color: percentage > 5 ? '#10b981' : '#f59e0b'
					}
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

{#if enpiData}
	<div class="enpi-container">
		<div class="enpi-chart" bind:this={chartContainer}></div>

		<div class="enpi-details">
			<div class="enpi-card card">
				<h4>Primary EnPI</h4>
				<div class="enpi-value">
					<span class="value">{enpiData.primary_enpi.value}</span>
					<span class="unit">{enpiData.primary_enpi.unit}</span>
				</div>
				<div class="enpi-comparison">
					<div class="comparison-item">
						<span class="label">Baseline:</span>
						<span class="value">{enpiData.primary_enpi.baseline_value} {enpiData.primary_enpi.unit}</span>
					</div>
					<div class="comparison-item">
						<span class="label">Target:</span>
						<span class="value">{enpiData.primary_enpi.target_value} {enpiData.primary_enpi.unit}</span>
					</div>
					<div class="comparison-item">
						<span class="label">Status:</span>
						<span class="status success">{enpiData.primary_enpi.status.replace('_', ' ').toUpperCase()}</span>
					</div>
				</div>
			</div>

			<div class="secondary-enpis">
				<h4>Secondary EnPIs</h4>
				{#each enpiData.secondary_enpis as enpi}
					<div class="enpi-item">
						<div class="enpi-name">{enpi.name}</div>
						<div class="enpi-values">
							<span class="current">{enpi.value} {enpi.unit}</span>
							<span class="improvement" style="color: var(--color-secondary)">
								↓ {enpi.improvement_percent.toFixed(1)}%
							</span>
						</div>
					</div>
				{/each}
			</div>
		</div>
	</div>
{/if}

<style>
	.enpi-container {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: var(--spacing-lg);
		margin-top: var(--spacing-md);
	}

	.enpi-chart {
		height: 350px;
	}

	.enpi-details {
		display: flex;
		flex-direction: column;
		gap: var(--spacing-md);
	}

	.enpi-card h4 {
		margin-bottom: var(--spacing-md);
		font-size: 1rem;
	}

	.enpi-value {
		display: flex;
		align-items: baseline;
		gap: 0.5rem;
		margin-bottom: var(--spacing-md);
	}

	.enpi-value .value {
		font-size: 2rem;
		font-weight: 700;
		color: var(--color-primary);
	}

	.enpi-value .unit {
		font-size: 0.875rem;
		color: var(--text-muted);
	}

	.enpi-comparison {
		display: flex;
		flex-direction: column;
		gap: var(--spacing-sm);
	}

	.comparison-item {
		display: flex;
		justify-content: space-between;
		font-size: 0.875rem;
	}

	.comparison-item .label {
		color: var(--text-muted);
	}

	.status {
		font-weight: 600;
	}

	.status.success {
		color: var(--color-secondary);
	}

	.secondary-enpis h4 {
		margin-bottom: var(--spacing-md);
		font-size: 1rem;
	}

	.enpi-item {
		padding: var(--spacing-md);
		background: var(--bg-secondary);
		border-radius: var(--border-radius);
		margin-bottom: var(--spacing-sm);
	}

	.enpi-name {
		font-size: 0.875rem;
		color: var(--text-secondary);
		margin-bottom: 0.25rem;
	}

	.enpi-values {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}

	.enpi-values .current {
		font-weight: 600;
		color: var(--text-primary);
	}

	.improvement {
		font-weight: 600;
		font-size: 0.875rem;
	}

	@media (max-width: 768px) {
		.enpi-container {
			grid-template-columns: 1fr;
		}
	}
</style>
