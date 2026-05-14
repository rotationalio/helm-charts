# beacon

Helm chart for [Beacon](https://github.com/rotationalio/beacon): StatefulSet with a dedicated PVC for Compass fixtures (`BEACON_COMPASS_FIXTURES`), optional Traefik `IngressRoute`, and OpenTelemetry via the `opentelemetry` library subchart.

See `values.yaml` for defaults. Use `global.origins` for CORS (`BEACON_ALLOWED_ORIGINS`). Set `beacon.auth.authorizedUsers.secretKeyRef` for Basic auth users (comma-separated `user:pass` in the secret value), matching `BEACON_AUTH_AUTHORIZED_USERS`.
