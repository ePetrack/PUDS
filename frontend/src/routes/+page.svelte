<script lang="ts">
	import { onMount } from 'svelte';
	import KpiCard from '$lib/components/KpiCard.svelte';
	import EnergyTrendChart from '$lib/components/EnergyTrendChart.svelte';
	import UtilityDistribution from '$lib/components/UtilityDistribution.svelte';
	import EnpiMetrics from '$lib/components/EnpiMetrics.svelte';
	import BuildingPerformance from '$lib/components/BuildingPerformance.svelte';
	import AlertsList from '$lib/components/AlertsList.svelte';

	let dashboardData: any = null;
	let loading = true;

	onMount(async () => {
		try {
			const response = await fetch('/api/dashboard/overview');
			dashboardData = await response.json();
		} catch (error) {
			console.error('Error fetching dashboard data:', error);
		} finally {
			loading = false;
		}
	});
</script>

<svelte:head>
	<title>Dashboard - PUDS</title>
</svelte:head>

<div class="dashboard">
	<header class="dashboard-header">
		<div>
			<h1>Energy Management Dashboard</h1>
			<p class="text-muted">Real-time utility performance monitoring and ISO 50001 compliance</p>
		</div>
		<div class="header-actions">
			<button class="btn btn-primary">Export Report</button>
		</div>
	</header>

	{#if loading}
		<div class="loading">Loading dashboard data...</div>
	{:else if dashboardData}
		<!-- KPI Cards -->
		<section class="kpi-section">
			<h2>Key Performance Indicators</h2>
			<div class="grid grid-cols-4 gap-md">
				<KpiCard
					title="Total Energy Consumption"
					value={dashboardData.kpis.total_energy_consumption.value}
					unit={dashboardData.kpis.total_energy_consumption.unit}
					change={dashboardData.kpis.total_energy_consumption.change_percent}
					status={dashboardData.kpis.total_energy_consumption.status}
				/>
				<KpiCard
					title="Energy Intensity"
					value={dashboardData.kpis.energy_intensity.value}
					unit={dashboardData.kpis.energy_intensity.unit}
					change={dashboardData.kpis.energy_intensity.change_percent}
					status={dashboardData.kpis.energy_intensity.status}
				/>
				<KpiCard
					title="Cost Savings"
					value={dashboardData.kpis.cost_savings.value}
					unit={dashboardData.kpis.cost_savings.unit}
					change={dashboardData.kpis.cost_savings.change_percent}
					status={dashboardData.kpis.cost_savings.status}
				/>
				<KpiCard
					title="Carbon Emissions"
					value={dashboardData.kpis.carbon_emissions.value}
					unit={dashboardData.kpis.carbon_emissions.unit}
					change={dashboardData.kpis.carbon_emissions.change_percent}
					status={dashboardData.kpis.carbon_emissions.status}
				/>
			</div>
		</section>

		<!-- Main Charts -->
		<section class="charts-section">
			<div class="grid grid-cols-2 gap-lg">
				<div class="card">
					<h3>Energy Consumption Trends</h3>
					<EnergyTrendChart />
				</div>
				<div class="card">
					<h3>Utility Distribution</h3>
					<UtilityDistribution data={dashboardData.energy_by_type} />
				</div>
			</div>
		</section>

		<!-- ISO 50001 EnPI Section -->
		<section class="enpi-section">
			<h2>ISO 50001 - Energy Performance Indicators</h2>
			<EnpiMetrics />
		</section>

		<!-- Building Performance & Alerts -->
		<section class="bottom-section">
			<div class="grid grid-cols-2 gap-lg">
				<div class="card">
					<h3>Building Performance Summary</h3>
					<BuildingPerformance data={dashboardData.building_summary} />
				</div>
				<div class="card">
					<h3>Active Alerts</h3>
					<AlertsList alerts={dashboardData.alerts} />
				</div>
			</div>
		</section>

		<!-- Action Plans Summary -->
		<section class="action-plans card">
			<h3>ISO 50001 Action Plans</h3>
			<div class="action-stats">
				<div class="stat">
					<span class="stat-value">{dashboardData.action_plans.total}</span>
					<span class="stat-label">Total Plans</span>
				</div>
				<div class="stat">
					<span class="stat-value">{dashboardData.action_plans.in_progress}</span>
					<span class="stat-label">In Progress</span>
				</div>
				<div class="stat">
					<span class="stat-value">{dashboardData.action_plans.completed_this_month}</span>
					<span class="stat-label">Completed This Month</span>
				</div>
				<div class="stat">
					<span class="stat-value">${dashboardData.action_plans.projected_annual_savings.toLocaleString()}</span>
					<span class="stat-label">Projected Annual Savings</span>
				</div>
			</div>
		</section>
	{/if}
</div>

<style>
	.dashboard {
		max-width: 1600px;
		margin: 0 auto;
	}

	.dashboard-header {
		display: flex;
		justify-content: space-between;
		align-items: flex-start;
		margin-bottom: var(--spacing-xl);
	}

	.dashboard-header h1 {
		margin-bottom: 0.5rem;
	}

	.header-actions {
		display: flex;
		gap: var(--spacing-sm);
	}

	section {
		margin-bottom: var(--spacing-xl);
	}

	section h2 {
		margin-bottom: var(--spacing-lg);
		font-size: 1.5rem;
	}

	section h3 {
		margin-bottom: var(--spacing-md);
		font-size: 1.125rem;
	}

	.loading {
		text-align: center;
		padding: var(--spacing-xl);
		color: var(--text-muted);
	}

	.action-stats {
		display: grid;
		grid-template-columns: repeat(4, 1fr);
		gap: var(--spacing-lg);
		margin-top: var(--spacing-lg);
	}

	.stat {
		text-align: center;
	}

	.stat-value {
		display: block;
		font-size: 2rem;
		font-weight: 700;
		color: var(--color-primary);
		margin-bottom: 0.5rem;
	}

	.stat-label {
		display: block;
		font-size: 0.875rem;
		color: var(--text-muted);
	}

	@media (max-width: 768px) {
		.action-stats {
			grid-template-columns: repeat(2, 1fr);
		}
	}
</style>
