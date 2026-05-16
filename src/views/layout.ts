function fmt(v: unknown): string {
  if (v === null || v === undefined) return '';
  if (typeof v === 'string') return v;
  if (typeof v === 'number' || typeof v === 'boolean') return String(v);
  if (typeof v === 'bigint') return v.toString();
  if (typeof v === 'object') return String(v);
  return String(v);
}

export function esc(v: unknown): string {
  return fmt(v).replace(/[&<>"']/g, (c) => {
    switch (c) {
      case '&': return '&amp;';
      case '<': return '&lt;';
      case '>': return '&gt;';
      case '"': return '&quot;';
      case "'": return '&#39;';
      default: return c;
    }
  });
}

export type Column<T> = {
  header: string;
  cell: (row: T) => string;
};

export function table<T>(rows: T[], cols: Column<T>[]): string {
  if (rows.length === 0) return `<p class="empty">No rows.</p>`;
  const head = cols.map((c) => `<th>${esc(c.header)}</th>`).join('');
  const body = rows
    .map((r) => '<tr>' + cols.map((c) => `<td>${c.cell(r)}</td>`).join('') + '</tr>')
    .join('');
  return `<table><thead><tr>${head}</tr></thead><tbody>${body}</tbody></table>`;
}

export function options<T>(
  items: readonly T[],
  value: (item: T) => unknown = (i) => i,
  label: (item: T) => unknown = (i) => i,
): string {
  return items
    .map((i) => `<option value="${esc(value(i))}">${esc(label(i))}</option>`)
    .join('');
}

const NAV = [
  ['/', 'Dashboard'],
  ['/sites', 'Sites'],
  ['/meters', 'Meters'],
  ['/readings', 'Readings'],
  ['/bills', 'Bills'],
  ['/budgets', 'Budgets'],
  ['/alerts', 'Alerts'],
] as const;

export function page(title: string, body: string, opts: { active?: string } = {}): string {
  const nav = NAV.map(([href, label]) => {
    const cls = opts.active === href ? ' class="active"' : '';
    return `<a href="${href}"${cls}>${label}</a>`;
  }).join('');
  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>PUDS — ${esc(title)}</title>
  <link rel="stylesheet" href="/styles.css" />
</head>
<body>
  <header><h1>PUDS</h1><nav>${nav}</nav></header>
  <main>
    <h2>${esc(title)}</h2>
    ${body}
  </main>
  <footer>Personal utility data system · DuckDB</footer>
</body>
</html>`;
}
