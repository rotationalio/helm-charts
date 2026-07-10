# Endeavor Chart

This chart deploys Endeavor and the embedded Quarterdeck subchart.

## Basic usage

Run from the `helm-charts` repository root.

```bash
helm dependency build ./charts/endeavor
helm template myrelease ./charts/endeavor -f ./my-values.yaml --namespace endeavor
```

Apply with Helm:

```bash
helm upgrade --install myrelease ./charts/endeavor -f ./my-values.yaml --namespace endeavor
```

## Secret model

This chart expects pre-existing Kubernetes secrets by default (`secrets.create=false`).

Common required secret keys:

- `databaseURL` (from `secrets.databaseURL`)
- `inferenceAPIKey` (from `secrets.inferenceAPIKey`)
- `cofferKeys` when coffer is enabled (from `secrets.cofferKeys`)
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` when S3 blobs are used (from `secrets.aws`)

Quarterdeck email is configured independently through `quarterdeck.quarterdeck.email.sendgrid`.

## Beacon task loader credentials

Beacon URL/TTL are configured from values:

- `endeavor.tasks.beacon.beaconUrl`
- `endeavor.tasks.beacon.beaconTTL`

Basic auth credentials now support **secret references** (preferred):

```yaml
endeavor:
  tasks:
    beacon:
      beaconUrl: "https://beacon.rotational.app"
      beaconTTL: "24h"
      authSecret:
        secretName: "my-tenant-endeavor"
        usernameKey: "beaconBasicAuthUsername"
        passwordKey: "beaconBasicAuthPassword"
```

Backwards-compatible inline fallback still works when `authSecret.secretName` is empty:

```yaml
endeavor:
  tasks:
    beacon:
      basicAuthUsername: ""
      basicAuthPassword: ""
```

## Full render reference

`ci/full-template-values.yaml` sets every parent-chart value to concrete sample data for render review. It is for local/CI rendering, not production.

```bash
helm template myrelease /Users/chris/Repositories/Rotational.io/helm-charts/charts/endeavor \
  -f /Users/chris/Repositories/Rotational.io/helm-charts/charts/endeavor/ci/full-template-values.yaml \
  --namespace rotational
```

For smaller checks, use `ci/all-values.yaml` or chart defaults only.
