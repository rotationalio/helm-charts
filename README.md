# Rotational Helm Charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/rotational)](https://artifacthub.io/packages/search?repo=rotational)

Helm charts for Kubernetes deployment of Rotational services.

## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

```
$ helm repo add rotational https://helm.rotational.dev
```

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
rotational` to see the charts.

## Available Charts

### Services

- [Endeavor](charts/endeavor/README.md)
- [Quarterdeck](charts/quarterdeck/README.md)
- [FanTail](charts/fantail/README.md)
- [Honu](charts/honu/README.md)
- [Linode ACME Webhook for cert-manager](charts/acme-linode/README.md)
- [Geoping](charts/geoping/README.md)
- [Vanity](charts/vanity/README.md)

### Subcharts (Tools)

- [Genoa](charts/genoa/README.md)
- [Region Info](charts/regioninfo/README.md)
- [OpenTelemetry](charts/opentelemetry/README.md)

## Debugging Templates

- Use `helm lint` to ensure your chart follows best practices.
- Use `helm template --debug` to render chart templates locally
- Use `helm install --dry-run --debug` to render chart locally without installing certs in the cluster, setting `--dry-run=server` will also perform any lookups on the server.

For example, to debug the Endeavor charts; in the `charts/endeavor` directory, run:

```
$ helm template --debug endeavor . --values ci/all-values.yaml
```

## Developer Guide

This section creates describes some of the best practices when developing charts for Rotational. Some of these best practices are rotational-specific and override the helm defaults when creating charts.

To create a new chart:

```
$ helm create -p scaffold ./charts/[name]
```

This will create a new chart with name [name] in the `./charts` directory. The scaffold setup ensures that things are setup the rotational way.

Some key differences:

- Inclusion of a `global` values object
- Use of `pod.annotations` instead of `podAnnotations` etc.
- Use of a Traefik ingress instead of an httproute.
- Removal of the `hpa.yaml` and serviceaccount.yaml` templates
- Updates to the `NOTES.txt` template
- Use of an `app` configuration dictionary for application specific values
- Use of a config map to inject non-secret environment variables.

### Application configuration

All application-specific values should either be in the `global` values (if common to all Rotational microservices) or in the `app` values if specific to the application.

If the configuration is not sensitive (e.g. does not need to be stored in a secret) then it should be added to the `configmap.yaml` as the correct environment variable. This is then loaded into the pod via the `envFrom` with a `configMapRef`.

If the configuration is sensitive it should be stored in a secret. See secrets below for how to define and create these secrets. These will then be loaded into the pod environment via the `env` specification.

A note on precedence: If a variable name exists in both the ConfigMap (`envFrom`) and the manual list (`env`), the manual env block takes precedence and overrides the value from the ConfigMap, regardless of which block is written first in the YAML.

### Secrets

When specifying

### Versioning

Application versions should be the semantic version of the Rotational release without the `v` prefix. The application version and the chart version _need not match_ (this is a change from how we did things previously).

Chart versions are updated as follows:

1. If the change is a hotfix or a bug fix, increment the patch version.
2. If we're adding configuration or values that are backwards compatible, increment the minor version.
3. If we're adding templates or making backwards incompatible changes, increment the major version.

This means that chart versions will have fairly large major versions compared to application versions since many chart changes tend not to be backwards compatible.