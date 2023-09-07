HASH=abc72bea09259eeea96646d0414a14539e18d02a
OLD_HASH=

.PHONY: all
all: $(HASH)/admission-webhook.yaml $(HASH)/jupyter-web-app.yaml

.PHONY: clean
clean:
	rm -rf $(HASH)
	rm -rf manifests

$(HASH)/admission-webhook.yaml: $(HASH)
	kubectl kustomize manifests/apps/admission-webhook/upstream/overlays/cert-manager > $(HASH)/admission-webhook.yaml

$(HASH)/jupyter-web-app.yaml: $(HASH)
	kubectl kustomize manifests/apps/jupyter/jupyter-web-app/upstream/overlays/istio > $(HASH)/jupyter-web-app.yaml

manifests:
	git clone git@github.com:kubeflow/manifests.git

	pushd manifests \
	&& git switch -d $(HASH) \
	&& popd

$(HASH): manifests
	mkdir -p $(HASH)
