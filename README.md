# Rotational Helm Charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/rotational)](https://artifacthub.io/packages/search?repo=rotational)

Helm charts for Kubernetes deployment of Rotational services.

## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

  helm repo add rotational https://helm.rotational.dev

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
rotational` to see the charts.

## Available Charts

- [Parlance](charts/parlance/README.md)

## Debugging Templates

- Use `helm lint` to ensure your chart follows best practices.
- Use `helm template --debug` to render chart templates locally
- Use `helm install --dry-run --debug` to render chart locally without installing certs in the cluster, setting `--dry-run=server` will also perform any lookups on the server.

For example, to debug the parlance charts; in the `charts/parlance` directory, run:

```
$ helm template --debug parlance . --values examples/values.yaml
```