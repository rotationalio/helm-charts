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
- `cofferKeys` when coffer is enabled (from `secrets.cofferKeys`)
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` when S3 blobs are used (from `secrets.aws`)

Quarterdeck email is configured independently through `quarterdeck.quarterdeck.email.sendgrid`.

## Beacon task loader credentials

Beacon URL/TTL are configured from values:

- `endeavor.tasks.beacon.url`
- `endeavor.tasks.beacon.ttl`

Basic auth credentials support **secret references**:

```yaml
endeavor:
  tasks:
    beacon:
      url: "https://beacon.rotational.app"
      ttl: "24h"
      compassVersion: "0.37.0"
      authSecret:
        secretName: "my-tenant-endeavor"
        usernameKey: "beaconBasicAuthUsername"
        passwordKey: "beaconBasicAuthPassword"
```

## Full render reference

`ci/full-template-values.yaml` sets every parent-chart value to concrete sample data for render review. It is for local/CI rendering, not production.

```bash
helm template myrelease /Users/chris/Repositories/Rotational.io/helm-charts/charts/endeavor \
  -f /Users/chris/Repositories/Rotational.io/helm-charts/charts/endeavor/ci/full-template-values.yaml \
  --namespace rotational
```

For smaller checks, use `ci/all-values.yaml` or chart defaults only.

## Current Environment Configuration

Radish queue connection settings are managed by Endeavor's store. Configure task
queue behavior with the `RADISH_*` tunables below; do not use
`ENDEAVOR_RADISH_*` variables.

## Fetch Metadata CSRF protection

Endeavor uses Gimlet's Fetch Metadata CSRF protection. Same-origin mutations pass;
same-site mutations require a trusted exact `Origin`. Requests with missing or
unknown fetch metadata require a trusted `Origin` or `Referer`. Explicit cross-site
mutations and `Sec-Fetch-Site: none` mutations are rejected by default. Safe methods
default to `GET,HEAD,OPTIONS`.

Configure the middleware under `endeavor.csrf`. `expectedOrigins` is separate from
CORS `allowOrigins`; when it is empty, Endeavor uses the resolved CORS origins
(`endeavor.allowOrigins`, `global.origins`, or `endeavor.origin`, in that order).
Specify a non-empty `expectedOrigins` list to override this fallback. Origins must
be exact browser-facing HTTP(S) origins (scheme and host, including a non-default
port when applicable), with no wildcard domains or URL paths. Lists are exported
as comma-separated environment variables. Boolean relaxations default to `false`,
and fetch mode/destination allowlists default to empty.

For example, these configured origins automatically become the CSRF expected origins
unless `endeavor.csrf.expectedOrigins` is set explicitly:

```yaml
global:
  origins:
    - https://endeavor.example.com
    - https://quarterdeck.example.com
endeavor:
  origin: https://endeavor.example.com
  csrf:
    namespace: endeavor
    disable: false
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

The expected-origin trust list and CORS `allowOrigins` list serve different policies.
The namespace configures Endeavor's CSRF error response header; it is separate from
`endeavor.auth.quarterdeckCSRFNamespace`, which determines the header Endeavor expects
from Quarterdeck. Preserve the existing authentication cookie settings when changing
CSRF configuration.

When Quarterdeck is enabled as Endeavor's dependency, configure its CSRF middleware at
`quarterdeck.quarterdeck.csrf` (the first `quarterdeck` selects the dependency chart):

```yaml
quarterdeck:
  enabled: true
  quarterdeck:
    csrf:
      namespace: quarterdeck
      disable: false
      # Empty uses Quarterdeck's resolved CORS origins; a non-empty list overrides them.
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

Quarterdeck's empty `expectedOrigins` falls back to its own resolved CORS origins
(`quarterdeck.allowOrigins`, `global.origins`, or `global.issuer`). This configuration
is independent of Endeavor's `endeavor.csrf` settings.

```text
This application is configured via the environment. The following environment
variables can be used:

ENDEAVOR_MAINTENANCE
  [description] if true, the server will start in maintenance mode
  [type]        True or False
  [default]     false
  [required]
ENDEAVOR_MODE
  [description] specify the mode of the server (release, debug, testing)
  [type]        String
  [default]     release
  [required]
ENDEAVOR_LOG_LEVEL
  [description] specify the verbosity of logging (trace, debug, info, warn, error, fatal, or panic)
  [type]        LevelDecoder
  [default]     info
  [required]
ENDEAVOR_CONSOLE_LOG
  [description] if true logs human readable text output instead of json
  [type]        True or False
  [default]     false
  [required]
ENDEAVOR_BIND_ADDR
  [description] the ip address and port to bind the web server on
  [type]        String
  [default]     :8000
  [required]
ENDEAVOR_ORIGIN
  [description] origin (url) of the web ui for creating endpoints and CORS access
  [type]        String
  [default]     http://localhost:8000
  [required]
ENDEAVOR_ALLOW_ORIGINS
  [description] a list of allowed origins (domains including port) for CORS requests
  [type]        Comma-separated list of String
  [default]     http://localhost:8000,http://localhost:8888
  [required]
ENDEAVOR_DOCS_NAME
  [description] the display title for the API docs
  [type]        String
  [default]     Endeavor API Reference
  [required]
ENDEAVOR_ORGANIZATION_ID
  [description] a string identifier for the organization that this endeavor instance serves
  [type]        String
  [default]     endeavor
  [required]
ENDEAVOR_DATABASE_URL
  [description] dsn containing backend database configuration
  [type]        String
  [default]     postgres://localhost:5432/endeavor
  [required]
ENDEAVOR_READ_HEADER_TIMEOUT
  [description] the maximum duration for reading the request header (see Go&#39;s http.Server.ReadHeaderTimeout)
  [type]        Duration
  [default]     180s
  [required]
ENDEAVOR_WRITE_TIMEOUT
  [description] the maximum duration for writing the response (see Go&#39;s http.Server.WriteTimeout)
  [type]        Duration
  [default]     180s
  [required]
ENDEAVOR_IDLE_TIMEOUT
  [description] the maximum duration for idle connections (see Go&#39;s http.Server.IdleTimeout)
  [type]        Duration
  [default]     360s
  [required]
ENDEAVOR_SHUTDOWN_TIMEOUT
  [description] the maximum duration for shutting down the server
  [type]        Duration
  [default]     180s
  [required]
ENDEAVOR_BLOBS_URI
  [description] blob store URI (see config doc for examples)
  [type]        String
  [default]     file:///blobs
  [required]
ENDEAVOR_STATIC_SERVE
  [description] if true, static files will be served from the filesystem
  [type]        True or False
  [default]     true
  [required]
ENDEAVOR_STATIC_ROOT
  [description] the root directory for static files
  [type]        String
  [default]     pkg/web/static
  [required]
ENDEAVOR_STATIC_URL
  [description] the URL that static files are served from either a relative URL or a URL to a CDN
  [type]        String
  [default]     /static
  [required]
ENDEAVOR_AUTH_QUARTERDECK_URL
  [description] the base authentication endpoint for quarterdeck
  [type]        String
  [default]     http://localhost:8888
  [required]
ENDEAVOR_AUTH_AUDIENCE
  [description] value for the aud jwt claim
  [type]        String
  [default]     http://localhost:8000
  [required]
ENDEAVOR_CSRF_DISABLED
  [description] if true, logs would-be CSRF rejections without blocking requests
  [type]        True or False
  [default]     false
  [required]
ENDEAVOR_CSRF_NAMESPACE
  [description] namespace used for Endeavor's CSRF error response header
  [type]        String
  [default]     endeavor
  [required]
ENDEAVOR_AUTH_QUARTERDECK_CSRF_NAMESPACE
  [description] namespace used for the CSRF error response header expected from Quarterdeck
  [type]        String
  [default]     quarterdeck
  [required]
ENDEAVOR_CSRF_EXPECTED_ORIGINS
  [description] exact trusted browser-facing HTTP(S) origins; defaults to the resolved CORS allowed origins
  [type]        Comma-separated list of String
  [default]     resolved CORS origins
  [required]
ENDEAVOR_CSRF_SAFE_HTTP_METHODS
  [description] methods that are safe from CSRF checks
  [type]        Comma-separated list of String
  [default]     GET,HEAD,OPTIONS
  [required]
ENDEAVOR_CSRF_ALLOW_MISSING_METADATA
  [description] allow requests missing Fetch Metadata headers
  [type]        True or False
  [default]     false
  [required]
ENDEAVOR_CSRF_ALLOW_UNKNOWN_SITE
  [description] allow requests with unknown Fetch Metadata site values
  [type]        True or False
  [default]     false
  [required]
ENDEAVOR_CSRF_ALLOW_SITE_NONE
  [description] allow requests with Sec-Fetch-Site: none
  [type]        True or False
  [default]     false
  [required]
ENDEAVOR_CSRF_ALLOWED_FETCH_MODES
  [description] allowed Sec-Fetch-Mode values
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_CSRF_ALLOWED_FETCH_DESTINATIONS
  [description] allowed Sec-Fetch-Dest values
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_CSRF_REQUIRE_FETCH_MODE
  [description] require a Sec-Fetch-Mode header
  [type]        True or False
  [default]     false
  [required]
ENDEAVOR_CSRF_REQUIRE_FETCH_DESTINATION
  [description] require a Sec-Fetch-Dest header
  [type]        True or False
  [default]     false
  [required]
ENDEAVOR_SECURE_CONTENT_TYPE_NOSNIFF
  [description] If true, adds the X-Content-Type-Options header with the nosniff directive.
  [type]        True or False
  [default]     true
  [required]
ENDEAVOR_SECURE_CROSS_ORIGIN_OPENER_POLICY
  [description] Value for the Cross-Origin-Opener-Policy header.
  [type]        String
  [default]     same-origin
  [required]
ENDEAVOR_SECURE_REFERRER_POLICY
  [description] Value for the Referrer-Policy header.
  [type]        String
  [default]     strict-origin-when-cross-origin
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_CHILD_SRC
  [description] defines valid sources for web workers and nested browsing contexts loading using elements such as &lt;frame&gt; and &lt;iframe&gt;.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_CONNECT_SRC
  [description] restricts the URLs which can be loaded using script interfaces.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_DEFAULT_SRC
  [description] serves as a fallback for the other fetch directives.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_FENCED_FRAME_SRC
  [description] specifies valid sources for nested browsing contexts loaded into &lt;fencedframe&gt; elements.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_FONT_SRC
  [description] specifies valid sources for fonts loaded using @font-face.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_FRAME_SRC
  [description] specifies valid sources for nested browsing contexts loaded into elements such as &lt;frame&gt; and &lt;iframe&gt;.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_IMG_SRC
  [description] specifies valid sources of images and favicons.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_MANIFEST_SRC
  [description] specifies valid sources of application manifest files.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_MEDIA_SRC
  [description] specifies valid sources for loading media using the &lt;audio&gt;, &lt;video&gt; and &lt;track&gt; elements.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_OBJECT_SRC
  [description] specifies valid sources for the &lt;object&gt; and &lt;embed&gt; elements.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_PREFETCH_SRC
  [description] specifies valid sources to be prefetched or prerendered.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_SCRIPT_SRC
  [description] specifies valid sources for JavaScript and WebAssembly resources.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_SCRIPT_SRC_ELEM
  [description] specifies valid sources for JavaScript &lt;script&gt; elements.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_SCRIPT_SRC_ATTR
  [description] specifies valid sources for JavaScript inline event handlers.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_STYLE_SRC
  [description] specifies valid sources for stylesheets.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_STYLE_SRC_ELEM
  [description] specifies valid sources for stylesheets &lt;style&gt; elements and &lt;link&gt; elements with rel=&#34;stylesheet&#34;.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_STYLE_SRC_ATTR
  [description] specifies valid sources for stylesheets inline style attributes.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_WORKER_SRC
  [description] specifies valid sources for worker, shared worker, or service worker scripts.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_BASE_URI
  [description] restricts the URLs which can be used in a document&#39;s &lt;base&gt; element.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_SANDBOX
  [description] enables a sandbox for the requested resource similar to the &lt;iframe&gt; sandbox attribute.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_FORM_ACTION
  [description] specifies valid sources for the &lt;form&gt; element&#39;s action attribute.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_FRAME_ANCESTORS
  [description] specifies valid parents that may embed a page using &lt;frame&gt;, &lt;iframe&gt;, &lt;object&gt;, or &lt;embed&gt;.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_TO
  [description] provides the browser with a token identifying the reporting endpoint or group of endpoints to send CSP violation information to.
  [type]        String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REQUIRE_TRUSTED_TYPES_FOR
  [description] enforces Trusted Types at the DOM XSS injection sinks.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_TRUSTED_TYPES
  [description] used to specify an allowlist of Trusted Types policies.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_UPGRADE_INSECURE_REQUESTS
  [description] instructs user agents to treat all of a site&#39;s insecure URLs (those served over HTTP) as though they have been replaced with secure URLs (those served over HTTPS).
  [type]        True or False
  [default]     false
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_CHILD_SRC
  [description] defines valid sources for web workers and nested browsing contexts loading using elements such as &lt;frame&gt; and &lt;iframe&gt;.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_CONNECT_SRC
  [description] restricts the URLs which can be loaded using script interfaces.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_DEFAULT_SRC
  [description] serves as a fallback for the other fetch directives.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_FENCED_FRAME_SRC
  [description] specifies valid sources for nested browsing contexts loaded into &lt;fencedframe&gt; elements.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_FONT_SRC
  [description] specifies valid sources for fonts loaded using @font-face.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_FRAME_SRC
  [description] specifies valid sources for nested browsing contexts loaded into elements such as &lt;frame&gt; and &lt;iframe&gt;.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_IMG_SRC
  [description] specifies valid sources of images and favicons.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_MANIFEST_SRC
  [description] specifies valid sources of application manifest files.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_MEDIA_SRC
  [description] specifies valid sources for loading media using the &lt;audio&gt;, &lt;video&gt; and &lt;track&gt; elements.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_OBJECT_SRC
  [description] specifies valid sources for the &lt;object&gt; and &lt;embed&gt; elements.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_PREFETCH_SRC
  [description] specifies valid sources to be prefetched or prerendered.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_SCRIPT_SRC
  [description] specifies valid sources for JavaScript and WebAssembly resources.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_SCRIPT_SRC_ELEM
  [description] specifies valid sources for JavaScript &lt;script&gt; elements.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_SCRIPT_SRC_ATTR
  [description] specifies valid sources for JavaScript inline event handlers.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_STYLE_SRC
  [description] specifies valid sources for stylesheets.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_STYLE_SRC_ELEM
  [description] specifies valid sources for stylesheets &lt;style&gt; elements and &lt;link&gt; elements with rel=&#34;stylesheet&#34;.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_STYLE_SRC_ATTR
  [description] specifies valid sources for stylesheets inline style attributes.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_WORKER_SRC
  [description] specifies valid sources for worker, shared worker, or service worker scripts.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_BASE_URI
  [description] restricts the URLs which can be used in a document&#39;s &lt;base&gt; element.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_SANDBOX
  [description] enables a sandbox for the requested resource similar to the &lt;iframe&gt; sandbox attribute.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_FORM_ACTION
  [description] specifies valid sources for the &lt;form&gt; element&#39;s action attribute.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_FRAME_ANCESTORS
  [description] specifies valid parents that may embed a page using &lt;frame&gt;, &lt;iframe&gt;, &lt;object&gt;, or &lt;embed&gt;.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_REPORT_TO
  [description] provides the browser with a token identifying the reporting endpoint or group of endpoints to send CSP violation information to.
  [type]        String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_REQUIRE_TRUSTED_TYPES_FOR
  [description] enforces Trusted Types at the DOM XSS injection sinks.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_TRUSTED_TYPES
  [description] used to specify an allowlist of Trusted Types policies.
  [type]        Comma-separated list of String
  [default]
  [required]
ENDEAVOR_SECURE_CONTENT_SECURITY_POLICY_REPORT_ONLY_UPGRADE_INSECURE_REQUESTS
  [description] instructs user agents to treat all of a site&#39;s insecure URLs (those served over HTTP) as though they have been replaced with secure URLs (those served over HTTPS).
  [type]        True or False
  [default]     false
  [required]
ENDEAVOR_SECURE_REPORTING_ENDPOINTS
  [description] Reporting endpoints for reports generated by the Reporting API such as CSP violations or cross-origin-opener policy reports. The map key is the endpoint name, the value is the URL.
  [type]        Comma-separated list of String:String pairs
  [default]
  [required]
ENDEAVOR_SECURE_HSTS_SECONDS
  [description] If non-zero, the HSTS directive header is added to responses. The time, in seconds, that the browser should remember that a host is only to be accessed using HTTPS.
  [type]        Integer
  [default]     0
  [required]
ENDEAVOR_SECURE_HSTS_INCLUDE_SUBDOMAINS
  [description] If true adds the includeSubdomains directive to the HSTS header. It has no effect unless Seconds is set to a non-zero value.
  [type]        True or False
  [default]     false
  [required]
ENDEAVOR_SECURE_HSTS_PRELOAD
  [description] If true, adds the preload directive to the HSTS header. It has no effect unless Seconds is set to a non-zero value and IncludeSubdomains is true.
  [type]        True or False
  [default]     false
  [required]
ENDEAVOR_HORIZON_RENDERER_CACHE_SIZE
  [description] the size of the renderer cache
  [type]        Integer
  [default]     128
  [required]
ENDEAVOR_MCP_REFRESH_CONTROLLER_INTERVAL
  [description] the interval between checking if MCP integrations require refreshing and if so running the integration refresh task for that specific integration (deafult every 5 minutes)
  [type]        Duration
  [default]     5m
  [required]
ENDEAVOR_MCP_INTEGRATION_REFRESH_INTERVAL
  [description] the time interval between refreshing an integration by requesting all of it&#39;s MCP server&#39;s metadata and listing all capabilities (default every 60 minutes)
  [type]        Duration
  [default]     60m
  [required]
ENDEAVOR_CATALOG_SYNC_CONTROLLER_INTERVAL
  [description] interval between catalog sync controller runs (0 disables)
  [type]        Duration
  [default]     5m
  [required]
ENDEAVOR_CATALOG_PROVIDER_SYNC_INTERVAL
  [description] staleness threshold before re-syncing a provider catalog
  [type]        Duration
  [default]     60m
  [required]
ENDEAVOR_TASKS_ENABLE_LOADER
  [description] if true, tasks will be loaded from the specified path
  [type]        True or False
  [default]     false
  [required]
ENDEAVOR_TASKS_LOADER_PATH
  [description] the path to the tasks loader package; this should point to a ZIP file that contains the Horizon tasks archive.
  [type]        String
  [default]     tasks
  [required]
ENDEAVOR_TASKS_BEACON_URL
  [description] the base URL of the Beacon fixture API
  [type]        String
  [default]
  [required]
ENDEAVOR_TASKS_BEACON_TTL
  [description] how often Beacon fixtures should be refreshed
  [type]        Duration
  [default]     0s
  [required]
ENDEAVOR_TASKS_BEACON_COMPASS_VERSION
  [description] the specific semver version of the Compass fixture to use; if empty, the beacon client will retrieve the latest fixture for the Endeavor version running
  [type]        String
  [default]
  [required]
ENDEAVOR_TASKS_BEACON_CREDENTIALS_TYPE
  [description] the type of credentials being described in the environment variables
  [type]        String
  [default]
  [required]
ENDEAVOR_TASKS_BEACON_CREDENTIALS_APIKEY
  [description] required for api key authentication
  [type]        String
  [default]
  [required]
ENDEAVOR_TASKS_BEACON_CREDENTIALS_ORGANIZATION
  [description] required for openai organization authentication
  [type]        String
  [default]
  [required]
ENDEAVOR_TASKS_BEACON_CREDENTIALS_PROJECT
  [description] required for openai organization authentication
  [type]        String
  [default]
  [required]
ENDEAVOR_TASKS_BEACON_CREDENTIALS_TOKEN
  [description] required for token authentication
  [type]        String
  [default]
  [required]
ENDEAVOR_TASKS_BEACON_CREDENTIALS_USERNAME
  [description] required for basic authentication
  [type]        String
  [default]
  [required]
ENDEAVOR_TASKS_BEACON_CREDENTIALS_PASSWORD
  [description] required for basic authentication
  [type]        String
  [default]
  [required]
ENDEAVOR_TASKS_BEACON_CREDENTIALS_CLIENT_ID
  [description] required for oauth2 client authentication
  [type]        String
  [default]
  [required]
ENDEAVOR_TASKS_BEACON_CREDENTIALS_CLIENT_SECRET
  [description] required for oauth2 client authentication
  [type]        String
  [default]
  [required]
ENDEAVOR_TASKS_BEACON_CREDENTIALS_REFRESH_TOKEN
  [description] required for oauth2 refresh token authentication
  [type]        String
  [default]
  [required]
ENDEAVOR_COMPASS_BASE
  [description] the base url of the compass endpoint
  [type]        String
  [default]     http://127.0.0.1:8000
  [required]
ENDEAVOR_COMPASS_TIMEOUT
  [description] the timeout for the compass client
  [type]        Duration
  [default]     150s
  [required]
RADISH_MANAGED_DB
  [description] use the database connection managed by Endeavor's store instead of connecting to a separate DSN
  [type]        True or False
  [default]     true
  [required]
RADISH_NUM_WORKERS
  [description] the number of workers to use for the task queue
  [type]        Integer
  [default]     8
  [required]
RADISH_TASK_RETRIES
  [description] the number of retry attempts for failed tasks
  [type]        Integer
  [default]     3
  [required]
RADISH_TASK_TIMEOUT
  [description] the maximum duration a task may run
  [type]        Duration
  [default]     60s
  [required]
RADISH_CLEANUP_TIMEOUT
  [description] the amount of time to allow task cleanup operations to complete after worker execution
  [type]        Duration
  [default]     5s
  [required]
RADISH_POLL_INTERVAL
  [description] interval between queue polling attempts
  [type]        Duration
  [default]     5s
  [required]
RADISH_POLL_JITTER
  [description] jitter added to the queue poll interval
  [type]        Duration
  [default]     125ms
  [required]
RADISH_RETENTION
  [description] duration completed tasks are retained
  [type]        Duration
  [default]     24h
  [required]
RADISH_VACUUM_INTERVAL
  [description] interval between completed-task cleanup runs
  [type]        Duration
  [default]     3h
  [required]
RADISH_BACKOFF_POLICY
  [description] retry backoff policy
  [type]        String
  [default]     linear
  [required]
RADISH_BACKOFF_DELAY
  [description] initial delay between task retries
  [type]        Duration
  [default]     10s
  [required]
RADISH_BACKOFF_FACTOR
  [description] multiplier applied to retry backoff delay
  [type]        Float
  [default]     2.0
  [required]
RADISH_BACKOFF_JITTER
  [description] whether retry backoff uses jitter
  [type]        True or False
  [default]     false
  [required]
RADISH_BACKOFF_SIGMA
  [description] standard deviation used for retry backoff jitter
  [type]        Duration
  [default]     750ms
  [required]
ENDEAVOR_TELEMETRY_ENABLED
  [description] disable telemetry by setting this environment variable to false
  [type]        True or False
  [default]     true
  [required]
OTEL_SERVICE_NAME
  [description] override the default name of the service, used for logging and telemetry
  [type]        String
  [default]
  [required]
GIMLET_OTEL_SERVICE_ADDR
  [description] the primary server name if it is known. E.g. the server name directive in an Nginx config. Should include host identifier and port if it is used; empty if not known.
  [type]        String
  [default]
  [required]
ENDEAVOR_BACKUP_ENABLE_API
  [description] when true, registers authenticated GET /v1/backup on the API
  [type]        True or False
  [default]     false
  [required]
ENDEAVOR_COFFER_ENABLED
  [description] verify configured PKCS#8 keys against coffer_keys at startup; disable to skip coffer.Init
  [type]        True or False
  [default]     false
  [required]
ENDEAVOR_COFFER_KEYS
  [description] namespace:base64-pkcs8; empty namespace is the default write namespace
  [type]        Comma-separated list of String:CofferKey pairs
  [default]
  [required]
```
