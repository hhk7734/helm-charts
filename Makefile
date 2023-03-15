package:
	helm package ./charts/knative-operator

template:
	helm template knative-operator ./charts/knative-operator > knative-operator-test.yaml
