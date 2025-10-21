<script lang="ts">
	export let data: any;
</script>

<div class="building-performance">
	<div class="summary-stats">
		<div class="stat-item">
			<span class="stat-value">{data.total_buildings}</span>
			<span class="stat-label">Total Buildings</span>
		</div>
		<div class="stat-item">
			<span class="stat-value">{data.total_sqft.toLocaleString()}</span>
			<span class="stat-label">Total Sq Ft</span>
		</div>
		<div class="stat-item">
			<span class="stat-value">{data.average_eui}</span>
			<span class="stat-label">Avg EUI (kBtu/sqft)</span>
		</div>
	</div>

	<div class="performance-lists">
		<div class="top-performers">
			<h5>Top Performers</h5>
			{#each data.top_performers as building}
				<div class="building-item success">
					<div class="building-name">{building.name}</div>
					<div class="building-metrics">
						<span class="eui">{building.eui} EUI</span>
						<span class="change positive">↓ {building.savings_percent}%</span>
					</div>
				</div>
			{/each}
		</div>

		<div class="needs-attention">
			<h5>Needs Attention</h5>
			{#each data.needs_attention as building}
				<div class="building-item warning">
					<div class="building-name">{building.name}</div>
					<div class="building-metrics">
						<span class="eui">{building.eui} EUI</span>
						<span class="change negative">↑ {Math.abs(building.increase_percent)}%</span>
					</div>
				</div>
			{/each}
		</div>
	</div>
</div>

<style>
	.building-performance {
		margin-top: var(--spacing-md);
	}

	.summary-stats {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: var(--spacing-md);
		margin-bottom: var(--spacing-lg);
		padding-bottom: var(--spacing-lg);
		border-bottom: 1px solid var(--border-color);
	}

	.stat-item {
		text-align: center;
	}

	.stat-value {
		display: block;
		font-size: 1.5rem;
		font-weight: 700;
		color: var(--color-primary);
		margin-bottom: 0.25rem;
	}

	.stat-label {
		display: block;
		font-size: 0.75rem;
		color: var(--text-muted);
	}

	.performance-lists {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: var(--spacing-lg);
	}

	h5 {
		font-size: 0.875rem;
		font-weight: 600;
		margin-bottom: var(--spacing-md);
		color: var(--text-secondary);
	}

	.building-item {
		padding: var(--spacing-md);
		border-radius: var(--border-radius);
		margin-bottom: var(--spacing-sm);
		border-left: 3px solid;
	}

	.building-item.success {
		background: rgba(16, 185, 129, 0.05);
		border-left-color: var(--color-secondary);
	}

	.building-item.warning {
		background: rgba(239, 68, 68, 0.05);
		border-left-color: var(--color-danger);
	}

	.building-name {
		font-weight: 500;
		margin-bottom: 0.25rem;
		color: var(--text-primary);
	}

	.building-metrics {
		display: flex;
		justify-content: space-between;
		align-items: center;
		font-size: 0.875rem;
	}

	.eui {
		color: var(--text-muted);
	}

	.change {
		font-weight: 600;
	}

	.change.positive {
		color: var(--color-secondary);
	}

	.change.negative {
		color: var(--color-danger);
	}

	@media (max-width: 768px) {
		.performance-lists {
			grid-template-columns: 1fr;
		}
	}
</style>
