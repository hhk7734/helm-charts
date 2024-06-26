.PHONY: index
index:
	helm repo index .

package:
	helm package ./charts/knative-operator
	helm package ./charts/kubeflow

.PHONY: remove_local
remove_local:
	git remote update --prune
	git switch --detach origin/main
	@git for-each-ref --format '%(refname:short)' refs/heads | xargs -r -t git branch -D

.PHONY: template
template: template_kubeflow template_rdma_shared_device_plugin template_mpi_operator

.PHONY: template_kubeflow
template_kubeflow: test
	helm lint ./charts/kubeflow

	helm template kubeflow ./charts/kubeflow --set crds.install=false > test/kubeflow-default.yaml

.PHONY: template_rdma_shared_device_plugin
template_rdma_shared_device_plugin: test
	helm lint ./charts/rdma-shared-device-plugin

	helm template rdma-shared-device-plugin ./charts/rdma-shared-device-plugin --set cdi.enabled=true > test/rdma-shared-device-plugin-default.yaml

.PHONY: template_mpi_operator
template_mpi_operator: test
	helm lint ./charts/mpi-operator

	helm template mpi-operator ./charts/mpi-operator --set crds.install=false > test/mpi-operator-default.yaml

test:
	mkdir test