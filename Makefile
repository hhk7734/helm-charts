package:
	helm package ./charts/knative-operator
	helm package ./charts/kubeflow

.PHONY: remove_local
remove_local:
	git remote update --prune
	git switch --detach origin/main
	@git for-each-ref --format '%(refname:short)' refs/heads | xargs -r -t git branch -D

.PHONY: template
template: template_kubeflow

.PHONY: template_kubeflow
template_kubeflow: test
	helm lint ./charts/kubeflow

	helm template kubeflow ./charts/kubeflow --set crds.install=false > test/kubeflow-default.yaml

test:
	mkdir test