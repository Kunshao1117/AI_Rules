# Performance Measurement Reference

## Distinct evidence

| Evidence | Interpretation limit |
|---|---|
| Browser lab run | Controlled observations for that build, device, workload and conditions |
| Real-user/field data | Observed population/time-window; device mix and sampling matter |
| Navigation/resource timing | Relevant loading/network intervals, not all runtime behavior or all Web Vitals |
| Runtime profile/trace | Where observed execution time/resources went; instrumentation can alter results |
| Lighthouse performance score | Tool/version-specific summary of lab metrics, not all performance truth |

Core Web Vitals currently cover LCP, INP and CLS. Use the applicable definitions,
collection context and thresholds from [official Web Vitals guidance](https://web.dev/articles/vitals)
(checked 2026-09-15). Navigation/load events are not substitutes for INP or LCP;
FID is historical rather than the current responsiveness Core Web Vital.
Do not impose web metrics on non-web runtime work.

When browser runtime evaluation is supported, an already observed page's
`performance.getEntriesByType("navigation")` and resource entries can provide
timing clues. This does not require a named browser tool or imply complete metric
collection. Use the provider's current supported API under its own capability rules.

For an existing compatible Lighthouse setup, prefer its project-declared command
and selected performance category; inspect command effects before execution.
No installation command, default server startup, fixed output path, all-page scan
or automatic SEO/accessibility audit is supplied. Scoring varies with metric
weights and test conditions; see [official Lighthouse scoring](https://developer.chrome.com/docs/lighthouse/performance/performance-scoring)
(checked 2026-09-15). Its other categories are not performance measurements.

For a regression, compare the same operation/build mode/cache/network/data where
feasible. Keep individual runs or a useful distribution; explain median/percentile
or other chosen summary and noise instead of blindly averaging. Investigate
resource size/count, expensive work, layout movement or timing relevant to the
claim. Field and lab discrepancies can be informative; neither erases the other.
