package:
	helm package ./charts/knative-operator

.PHONY: template
template: template_kubeflow

.PHONY: template_kubeflow
template_kubeflow: test
	helm lint ./charts/kubeflow

	helm template kubeflow ./charts/kubeflow > test/kubeflow-default.yaml

test:
	mkdir test