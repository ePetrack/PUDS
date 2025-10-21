<script lang="ts">
	import '../app.css';
</script>

<div class="app">
	<nav class="sidebar">
		<div class="logo">
			<h2>PUDS</h2>
			<p class="text-muted">Utility Management</p>
		</div>

		<ul class="nav-menu">
			<li><a href="/" class="nav-item active">Dashboard</a></li>
			<li><a href="/bills" class="nav-item">Bills Management</a></li>
			<li><a href="/utility-analytics" class="nav-item">Utility Analytics</a></li>
			<li><a href="/building-analytics" class="nav-item">Building Analytics</a></li>
			<li><a href="/financial" class="nav-item">Financial Performance</a></li>
			<li><a href="/facility" class="nav-item">Facility Management</a></li>
			<li><a href="/plant" class="nav-item">Plant Management</a></li>
			<li><a href="/organizations" class="nav-item">Organizations</a></li>
			<li><a href="/account" class="nav-item">Account Management</a></li>
			<li><a href="/historian" class="nav-item">Data Historian</a></li>
			<li><a href="/improvement" class="nav-item">Performance Improvement</a></li>
		</ul>

		<div class="nav-footer">
			<p class="text-muted">ISO 50001 Compliant</p>
			<p class="text-muted">APPA Standards</p>
		</div>
	</nav>

	<main class="main-content">
		<slot />
	</main>
</div>

<style>
	.app {
		display: flex;
		min-height: 100vh;
	}

	.sidebar {
		width: 260px;
		background: var(--bg-dark);
		color: var(--text-white);
		padding: var(--spacing-lg);
		display: flex;
		flex-direction: column;
		position: fixed;
		height: 100vh;
		overflow-y: auto;
	}

	.logo {
		margin-bottom: var(--spacing-xl);
		padding-bottom: var(--spacing-lg);
		border-bottom: 1px solid rgba(255, 255, 255, 0.1);
	}

	.logo h2 {
		color: var(--text-white);
		font-size: 1.75rem;
		margin-bottom: 0.25rem;
	}

	.nav-menu {
		list-style: none;
		flex: 1;
	}

	.nav-menu li {
		margin-bottom: var(--spacing-xs);
	}

	.nav-item {
		display: block;
		padding: 0.75rem 1rem;
		color: rgba(255, 255, 255, 0.7);
		text-decoration: none;
		border-radius: var(--border-radius);
		transition: all 0.2s;
		font-size: 0.875rem;
	}

	.nav-item:hover {
		background: rgba(255, 255, 255, 0.1);
		color: var(--text-white);
	}

	.nav-item.active {
		background: var(--color-primary);
		color: var(--text-white);
	}

	.nav-footer {
		padding-top: var(--spacing-lg);
		border-top: 1px solid rgba(255, 255, 255, 0.1);
		font-size: 0.75rem;
	}

	.nav-footer p {
		color: rgba(255, 255, 255, 0.5);
		margin-bottom: 0.25rem;
	}

	.main-content {
		flex: 1;
		margin-left: 260px;
		padding: var(--spacing-xl);
		max-width: 100%;
	}

	@media (max-width: 768px) {
		.sidebar {
			width: 200px;
		}

		.main-content {
			margin-left: 200px;
			padding: var(--spacing-md);
		}
	}
</style>
