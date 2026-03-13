# Vanity

Deploy a service that uses a config map to map vanity domains (e.g. `go.rtnl.ai/x`) to Go packages hosted at a `git` repository (e.g. `github.com/rotationalio/x`).

## Installation

```sh
helm repo add rotational https:/helm.rotational.dev
helm install vanity rotational/vanity \
    --namespace rotational --values vanity.yaml
```

A minimal `vanity.yaml` file is as follows:

```yaml
vanity:
  domain: go.rtnl.ai
  repositories:
    - repository: https://github.com/rotationalio/x
    - repository: https://github.com/rotationalio/confire
    - repository: https://github.com/rotationalio/vanity
    - repository: https://github.com/rotationalio/radish
    - repository: https://github.com/rotationalio/ulid
    - repository: https://github.com/rotationalio/honu
    - repository: https://github.com/rotationalio/endeavor
    - repository: https://github.com/rotationalio/quarterdeck
    - repository: https://github.com/rotationalio/gimlet
    - repository: https://github.com/rotationalio/acme-linode
```

This will create vanity domains at `go.rtnl.ai` for each of the repositories described.