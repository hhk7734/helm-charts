HASH=abc72bea09259eeea96646d0414a14539e18d02a
OLD_HASH=

ALL_DEPS = $(HASH)/centraldashboard.yaml
ALL_DEPS += $(HASH)/access-management.yaml
ALL_DEPS += $(HASH)/admission-webhook.yaml
ALL_DEPS += $(HASH)/jupyter-web-app.yaml
ALL_DEPS += $(HASH)/models-web-app.yaml

.PHONY: all
all: $(ALL_DEPS)

.PHONY: clean
clean:
	rm -rf $(HASH)
	rm -rf manifests

$(HASH)/centraldashboard.yaml: $(HASH)
	kubectl kustomize manifests/apps/centraldashboard/upstream/overlays/kserve > $(HASH)/centraldashboard.yaml

$(HASH)/access-management.yaml: $(HASH)
	kubectl kustomize manifests/apps/profiles/upstream/overlays/kubeflow > $(HASH)/access-management.yaml

$(HASH)/admission-webhook.yaml: $(HASH)
	kubectl kustomize manifests/apps/admission-webhook/upstream/overlays/cert-manager > $(HASH)/admission-webhook.yaml

$(HASH)/jupyter-web-app.yaml: $(HASH)
	kubectl kustomize manifests/apps/jupyter/jupyter-web-app/upstream/overlays/istio > $(HASH)/jupyter-web-app.yaml

$(HASH)/models-web-app.yaml: $(HASH)
	kubectl kustomize manifests/contrib/kserve/models-web-app/overlays/kubeflow > $(HASH)/models-web-app.yaml

manifests:
	git clone git@github.com:kubeflow/manifests.git

	pushd manifests \
	&& git switch -d $(HASH) \
	&& popd

$(HASH): manifests
	mkdir -p $(HASH)
