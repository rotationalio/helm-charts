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
$ helm create -p $PWD/starts/deployment ./charts/[name]
```

This will create a new chart with name [name] in the `./charts` directory. The starts setup ensures that things are setup the Rotational way.

Some key differences:

- Inclusion of a `global` values object
- Use of `pod.annotations` instead of `podAnnotations` etc.
- Use of a Traefik ingress instead of an httproute.
- Removal of the `hpa.yaml` and serviceaccount.yaml` templates
- Updates to the `NOTES.txt` template
- Use of an `app` configuration dictionary for application specific values
- Use of a config map to inject non-secret environment variables.

NOTE: The `-p` flag requires an absolute path, hence the use of `$PWD`. To avoid this, you can copy the contents of the starters directory to `~/Library/helm/starters` then use the name of the folder as the starter.

NOTE: The `Chart.yaml` file is not copied from starters, so make sure you update it with the following:

```yaml
apiVersion: v2
name: <CHARTNAME>
description: A Helm chart for <CHARTNAME>

# Project Information
home: https://rotational.io
icon: https://rotational.io/img/favicon.png
sources:
  - https://github.com/rotationalio/<CHARTNAME>
maintainers:
  - name: Rotational Labs
    email: support@rotational.io
keywords:
  - <CHARTNAME>

# A chart can be either an 'application' or a 'library' chart. Applications are deployed
# to clusters whereas library charts are used to share common utilities between charts.
type: application

# This is the chart version. This version number should be incremented each time you
# make changes to the chart and its templates, including the app version.
# Versions are expected to follow Semantic Versioning (https://semver.org/)
# See the README.md for more information on versioning.
version: 0.1.0

# This is the version number of the application being deployed. This version number
# should be incremented each time you make changes to the application.
appVersion: "1.0.0"

# Dependencies that the chart uses to render additional templates.
# Use helm dep update to ensure the Chart.lock file is up to date.
dependencies:
  - name: opentelemetry
    version: ~1.0
    repository: file://../opentelemetry
    condition: opentelemetry.enabled
  - name: regioninfo
    version: ~1.1
    repository: file://../regioninfo
    condition: regioninfo.enabled
```

### Application configuration

All application-specific values should either be in the `global` values (if common to all Rotational microservices) or in the `app` values if specific to the application.

If the configuration is not sensitive (e.g. does not need to be stored in a secret) then it should be added to the `configmap.yaml` as the correct environment variable. This is then loaded into the pod via the `envFrom` with a `configMapRef`.

If the configuration is sensitive it should be stored in a secret. See secrets below for how to define and create these secrets. These will then be loaded into the pod environment via the `env` specification.

A note on precedence: If a variable name exists in both the ConfigMap (`envFrom`) and the manual list (`env`), the manual env block takes precedence and overrides the value from the ConfigMap, regardless of which block is written first in the YAML.

### Secrets

When specifying a sensitive configuration value, we should add the configuration value to the `app` values as follows:

```yaml
app:
  databaseURL:
    value: ""
    secretKeyRef:
      name: ""
      key: databaseURL
```

Then in the `_environment.tpl` helper file, you would add the secret as follows:

```yaml
- name: APP_ENV_VAR
  {{- if .Values.app.databaseURL.value }}
  value: {{ .Values.app.databaseURL.value | quote}}
  {{- else }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.app.databaseURL.secretKeyRef.name | default (include foo.name .) }}
      key: {{ .Values.app.databaseURL.secretKeyRef.key }}
  {{- end }}
```

NOTE: `foo.name` above is the chart name helper to generate the secret key value.

The value of the configuration in the `.Values.app` dictionary is only used to hard set the value into the environment (not recommended). It is not used in the secret creation process.

If the user wants the chart to generate the secret (e.g. the helm process loads the secret from an environment or vault) then that definition is as follows:

```yaml
secrets:
  create: true

  databaseURL:
    value: "" # must be set by user to create this secret or it is skipped
    secretKey: databaseURL
```

Note that this is a similar structure to above but this is only used for creating the secret rather than creating the environment reference.

If you are creating files for mounting the secret, then use the following structure:

```yaml
secrets:
  create: true

  jwks:
    mountPath: /data/jwks
    secretName: "" # defaults to the chart default secret name with -jwks appended
    keys: {} # specify the filename/data pairs for the secret -- skipped if omitted
```

### Volumes and Volume Mounts

Volumes and volume mounts go hand in hand so define them as helpers in `_volumes.tpl`. To make our lives simpler keep the `volume` definition and the `volumeMount` definition together e.g.:

```
{{- define foo.jwks.volume -}}
...
{{- end -}}

{{- define foo.jwks.volumeMount -}}
...
{{- end -}}

{{- define foo.mtls.volume -}}
...
{{- end -}}

{{- define foo.mtls.volumeMount -}}
...
{{- end -}}
```

### Versioning

Application versions should be the semantic version of the Rotational release without the `v` prefix. The application version and the chart version _need not match_ (this is a change from how we did things previously).

Chart versions are updated as follows:

1. If the change is a hotfix or a bug fix, increment the patch version.
2. If we're adding configuration or values that are backwards compatible, increment the minor version.
3. If we're adding templates or making backwards incompatible changes, increment the major version.

This means that chart versions will have fairly large major versions compared to application versions since many chart changes tend not to be backwards compatible.