<script lang="ts">
	export let alerts: any[];

	const getSeverityColor = (severity: string) => {
		switch (severity) {
			case 'critical':
				return 'var(--color-danger)';
			case 'warning':
				return 'var(--color-warning)';
			case 'info':
				return 'var(--color-info)';
			default:
				return 'var(--text-muted)';
		}
	};

	const formatTimestamp = (timestamp: string) => {
		const date = new Date(timestamp);
		const now = new Date();
		const diff = now.getTime() - date.getTime();
		const hours = Math.floor(diff / (1000 * 60 * 60));

		if (hours < 1) {
			const minutes = Math.floor(diff / (1000 * 60));
			return `${minutes} minute${minutes !== 1 ? 's' : ''} ago`;
		}
		if (hours < 24) {
			return `${hours} hour${hours !== 1 ? 's' : ''} ago`;
		}
		const days = Math.floor(hours / 24);
		return `${days} day${days !== 1 ? 's' : ''} ago`;
	};
</script>

<div class="alerts-list">
	{#if alerts && alerts.length > 0}
		{#each alerts as alert}
			<div class="alert-item" style="border-left-color: {getSeverityColor(alert.severity)}">
				<div class="alert-header">
					<span class="severity-badge" style="background: {getSeverityColor(alert.severity)}">
						{alert.severity}
					</span>
					<span class="alert-time">{formatTimestamp(alert.timestamp)}</span>
				</div>
				<div class="alert-building">{alert.building}</div>
				<div class="alert-message">{alert.message}</div>
			</div>
		{/each}
		<button class="btn-view-all">View All Alerts</button>
	{:else}
		<div class="no-alerts">
			<p>No active alerts</p>
		</div>
	{/if}
</div>

<style>
	.alerts-list {
		margin-top: var(--spacing-md);
	}

	.alert-item {
		padding: var(--spacing-md);
		border-radius: var(--border-radius);
		background: var(--bg-secondary);
		margin-bottom: var(--spacing-sm);
		border-left: 3px solid;
		transition: background 0.2s;
	}

	.alert-item:hover {
		background: var(--bg-tertiary);
	}

	.alert-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: var(--spacing-sm);
	}

	.severity-badge {
		display: inline-block;
		padding: 0.25rem 0.5rem;
		border-radius: 4px;
		font-size: 0.75rem;
		font-weight: 600;
		color: white;
		text-transform: uppercase;
	}

	.alert-time {
		font-size: 0.75rem;
		color: var(--text-muted);
	}

	.alert-building {
		font-weight: 600;
		color: var(--text-primary);
		margin-bottom: 0.25rem;
		font-size: 0.875rem;
	}

	.alert-message {
		font-size: 0.875rem;
		color: var(--text-secondary);
	}

	.btn-view-all {
		width: 100%;
		padding: var(--spacing-sm);
		margin-top: var(--spacing-md);
		background: var(--bg-secondary);
		border: 1px solid var(--border-color);
		border-radius: var(--border-radius);
		cursor: pointer;
		font-weight: 500;
		transition: all 0.2s;
	}

	.btn-view-all:hover {
		background: var(--bg-tertiary);
		border-color: var(--color-primary);
		color: var(--color-primary);
	}

	.no-alerts {
		text-align: center;
		padding: var(--spacing-xl);
		color: var(--text-muted);
	}
</style>
