# Quarterdeck

## Fetch Metadata CSRF protection

Quarterdeck uses Gimlet's Fetch Metadata CSRF protection. Same-origin mutations pass; same-site mutations require a trusted exact `Origin`. Requests with missing or unknown fetch metadata require a trusted `Origin` or `Referer`. Explicit cross-site mutations and `Sec-Fetch-Site: none` mutations are rejected by default. Safe methods default to `GET,HEAD,OPTIONS`.

Configure the middleware under `quarterdeck.csrf`:

```yaml
quarterdeck:
  csrf:
    namespace: quarterdeck
    disable: false
    # Empty uses the chart's resolved CORS origins (quarterdeck.allowOrigins,
    # global.origins, or global.issuer, in that order).
    expectedOrigins: []
    safeHTTPMethods: [GET, HEAD, OPTIONS]
    allowMissingMetadata: false
    allowUnknownSite: false
    allowSiteNone: false
    allowedFetchModes: []
    allowedFetchDestinations: []
    requireFetchMode: false
    requireFetchDestination: false
```

`expectedOrigins` is a separate policy from CORS `allowOrigins`. It must contain exact browser-facing HTTP(S) origins, including scheme and non-default port when applicable; do not use wildcard domains or URL paths. Set `expectedOrigins` to a non-empty list to override the fallback. Lists are exported to the application as comma-separated environment variables. Boolean relaxations default to `false`; fetch mode and destination allowlists default to empty.

For example, with the following configured origins, leaving `expectedOrigins` empty trusts those same origins for CSRF checks:

```yaml
global:
  origins:
    - https://quarterdeck.example.com
    - https://endeavor.example.com
```

Authentication cookie settings are independent from this CSRF configuration and are not changed by these options.
