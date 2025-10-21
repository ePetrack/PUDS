<script lang="ts">
	export let title: string;
	export let value: number;
	export let unit: string;
	export let change: number;
	export let status: 'improving' | 'degrading' | 'stable' = 'stable';

	const getStatusColor = (status: string) => {
		switch (status) {
			case 'improving':
				return 'var(--color-secondary)';
			case 'degrading':
				return 'var(--color-danger)';
			default:
				return 'var(--text-muted)';
		}
	};

	const getStatusIcon = (status: string) => {
		switch (status) {
			case 'improving':
				return '↓';
			case 'degrading':
				return '↑';
			default:
				return '→';
		}
	};

	const formatValue = (val: number): string => {
		if (val >= 1000000) {
			return (val / 1000000).toFixed(2) + 'M';
		} else if (val >= 1000) {
			return (val / 1000).toFixed(2) + 'K';
		}
		return val.toLocaleString(undefined, { maximumFractionDigits: 2 });
	};
</script>

<div class="kpi-card card">
	<div class="kpi-header">
		<h4 class="kpi-title">{title}</h4>
	</div>
	<div class="kpi-value">
		<span class="value">{formatValue(value)}</span>
		<span class="unit">{unit}</span>
	</div>
	<div class="kpi-change" style="color: {getStatusColor(status)}">
		<span class="change-icon">{getStatusIcon(status)}</span>
		<span class="change-value">{Math.abs(change).toFixed(1)}%</span>
		<span class="change-label">vs last period</span>
	</div>
</div>

<style>
	.kpi-card {
		padding: var(--spacing-lg);
		transition: transform 0.2s, box-shadow 0.2s;
	}

	.kpi-card:hover {
		transform: translateY(-2px);
		box-shadow: var(--shadow-lg);
	}

	.kpi-title {
		font-size: 0.875rem;
		font-weight: 500;
		color: var(--text-secondary);
		margin-bottom: var(--spacing-md);
	}

	.kpi-value {
		display: flex;
		align-items: baseline;
		gap: 0.5rem;
		margin-bottom: var(--spacing-sm);
	}

	.value {
		font-size: 2rem;
		font-weight: 700;
		color: var(--text-primary);
	}

	.unit {
		font-size: 0.875rem;
		color: var(--text-muted);
	}

	.kpi-change {
		display: flex;
		align-items: center;
		gap: 0.25rem;
		font-size: 0.875rem;
		font-weight: 500;
	}

	.change-icon {
		font-size: 1.25rem;
	}

	.change-label {
		color: var(--text-muted);
		margin-left: 0.25rem;
	}
</style>
