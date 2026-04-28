# Endeavor

## Render a fully populated manifest locally

`ci/full-template-values.yaml` sets **every** key from [values.yaml](values.yaml) to a concrete value (including optional `ingress.hostname` for [NOTES.txt](templates/NOTES.txt)), and fills the **opentelemetry** library subchart (not present in `values.yaml` but passed through the parent release). Use it to review the full rendered output in one shot. It is not a production values file.

```bash
helm dependency build ./charts/endeavor
helm template myrelease ./charts/endeavor \
  -f ./charts/endeavor/ci/full-template-values.yaml \
  --namespace rotational
```

Run from the **helm-charts** repository root. The subchart under `charts/quarterdeck/` has its own `values.yaml`; this parent chart only exposes `quarterdeck.enabled` in `values.yaml`—add another `-f` with nested `quarterdeck.*` keys if you need every Quarterdeck option expanded in the render.

For a smaller CI-style render, use `ci/all-values.yaml` or plain `helm template myrelease ./charts/endeavor` (chart defaults only).
