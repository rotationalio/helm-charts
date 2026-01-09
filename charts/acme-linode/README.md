# Linode (Akamai) ACME Webhook Solver

An ACME DNS01 Webhook Solver for the Linode (now Akamai) [DNS Manager](https://techdocs.akamai.com/cloud-computing/docs/dns-manager); used generally with Linode LKE (Linode Kubernetes Engine) and not other Akamai DNS service providers. This solver is specifically for issuing LetsEncrypt certs into your kubernetes cluster with [cert-manager](https://cert-manager.io/).

## Installation

```sh
$ helm repo add rotational https://helm.rotational.dev
$ helm install acme-linode rotational/acme-linode \
    --namespace cert-manager --values myvalues.yaml
```

A minimal `myvalues.yaml` file is as follows:

```yaml
groupName: acme.mycompany.com

certManager:
  namespace: cert-manager
  serviceAccountName: cert-manager
```

The `groupName` avoids naming conflicts on the Kubernetes API, it should be set by the
to a unique domain that you own. This name must match the group name specified in the `ClusterIssuer` as described below.

**NOTE**: The solver needs the namespace and service account name of your installation of cert-manager. The above values are the cert-manager defaults, but they should be set to whatever your installation is. Also, it's usually just easiest to install the webhook into the same namespace as cert-manager.

## Linode API Tokens

To interact with the Linode DNS Manager, you'll need an API token. See [Getting Started with the Linode API](https://techdocs.akamai.com/linode-api/reference/get-started) for more information.

You can either manually create a secret as follows:

```shell
$ kubectl create secret generic linode-credentials \
  --namespace=cert-manager \
  --from-literal=token="<LINODE TOKEN>"
```

Or you can specify it in the values (e.g. if you're injecting the token from an environment variable or using kustomize):

```yaml
groupName: acme.mycompany.com

certManager:
  namespace: cert-manager
  serviceAccountName: cert-manager

# Specify the linode API token credential to be used by the acme-linode webhook.
secret:
  create: true
  name: "linode-credentials"
  key: "token"
  value: "<LINODE TOKEN>"
```

## Create Issuer

Define a cert-manager issuer that uses the webhook solver:

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: me@mycompany.com
    privateKeySecretRef:
      name: letsencrypt-staging
    solvers:
    - dns01:
      webhook:
        solverName: linode
        groupName: acme.mycompany.com
```

By default, the Linode API token will be obtained from the linode-credentials Secret in the same namespace as the solver defined above.

If you would prefer to use separate Linode API tokens for each namespace (e.g. in a multi-tenant environment or for different Linode accounts) you can specify the credentials as part of the issuer config:

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
  namespace: tenant
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: me@mycompany.com
    privateKeySecretRef:
      name: letsencrypt-staging
    solvers:
    - dns01:
      webhook:
        solverName: linode
        groupName: acme.mycompany.com
        config:
          apiKeySecretRef:
            name: linode-credentials
            key: token
```