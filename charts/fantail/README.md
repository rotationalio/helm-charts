# fantail

This is the helm chart for fantail, an MCP server based on [MCP toolbox for databases](https://mcp-toolbox.dev/documentation/introduction/). We created the fantail helm chart because we needed to test MCP integrations for Endeavor and there was no existing official helm chart for MCP toolbox.

MCP tools are specified as secrets. Secrets can contain one or more tools, but it may be helpful to specify them as separate `.yaml` files for maintainability. For example, the following command adds the `http-nws-secret` which contains tool specifications for NWS weather forecasts.

```bash
kubectl create secret generic http-nws-secret --from-file=tools/http_nws.yaml
```

Included tools must be specified in the `values.yaml` like so:

```yaml
storage:
  tools:
    - secret:
        name: http-nws-secret
```