- abc72bea09259eeea96646d0414a14539e18d02a

`./apps/pipeline/upstream/env/cert-manager/platform-agnostic-multi-user/kustomization.yaml`

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

bases:
  - ../base
namespace: kubeflow

# Pass proper arguments to cache-server to use cert-manager certificate
patches:
  - patch: |-
      - op: add
        path: /spec/template/spec/containers/0/args/-
        value: "--tls_cert_filename=tls.crt"
    target:
      kind: Deployment
      name: cache-server
  - patch: |-
      - op: add
        path: /spec/template/spec/containers/0/args/-
        value: "--tls_key_filename=tls.key"
    target:
      kind: Deployment
      name: cache-server
```

```shell
kustomize build ./apps/pipeline/upstream/base/installs/multi-user
```

cache-deployer 삭제

```shell
kustomize build ./apps/pipeline/upstream/base/metadata/base
```

```shell
kustomize build ./apps/pipeline/upstream/base/metadata/options/istio
```