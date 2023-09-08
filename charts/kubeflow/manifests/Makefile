HASH=abc72bea09259eeea96646d0414a14539e18d02a
OLD_HASH=

ALL_DEPS = $(HASH)/pipeline.yaml
ALL_DEPS += $(HASH)/centraldashboard.yaml
ALL_DEPS += $(HASH)/access-management.yaml
ALL_DEPS += $(HASH)/admission-webhook.yaml
ALL_DEPS += $(HASH)/notebook-controller.yaml
ALL_DEPS += $(HASH)/jupyter-web-app.yaml
ALL_DEPS += $(HASH)/volumes-web-app.yaml
ALL_DEPS += $(HASH)/models-web-app.yaml

.PHONY: all
all: $(ALL_DEPS)

.PHONY: clean
clean:
	rm -rf $(HASH)
	rm -rf manifests

.PHONY: diff
diff:
	@sh ./scripts/diff.sh $(OLD_HASH) $(HASH)

$(HASH)/pipeline.yaml: $(HASH)
	kubectl kustomize manifests/apps/pipeline/upstream/env/cert-manager/platform-agnostic-multi-user > $(HASH)/pipeline.yaml

$(HASH)/centraldashboard.yaml: $(HASH)
	kubectl kustomize manifests/apps/centraldashboard/upstream/overlays/kserve > $(HASH)/centraldashboard.yaml

$(HASH)/access-management.yaml: $(HASH)
	kubectl kustomize manifests/apps/profiles/upstream/overlays/kubeflow > $(HASH)/access-management.yaml

$(HASH)/admission-webhook.yaml: $(HASH)
	kubectl kustomize manifests/apps/admission-webhook/upstream/overlays/cert-manager > $(HASH)/admission-webhook.yaml

$(HASH)/notebook-controller.yaml: $(HASH)
	kubectl kustomize manifests/apps/jupyter/notebook-controller/upstream/overlays/kubeflow > $(HASH)/notebook-controller.yaml

$(HASH)/jupyter-web-app.yaml: $(HASH)
	kubectl kustomize manifests/apps/jupyter/jupyter-web-app/upstream/overlays/istio > $(HASH)/jupyter-web-app.yaml

$(HASH)/volumes-web-app.yaml: $(HASH)
	kubectl kustomize manifests/apps/volumes-web-app/upstream/overlays/istio > $(HASH)/volumes-web-app.yaml

$(HASH)/models-web-app.yaml: $(HASH)
	kubectl kustomize manifests/contrib/kserve/models-web-app/overlays/kubeflow > $(HASH)/models-web-app.yaml

manifests:
	git clone git@github.com:kubeflow/manifests.git

.PHONY: manifests_switch
manifests_switch: manifests
	pushd manifests \
	&& git switch -d $(HASH) \
	&& popd

$(HASH): manifests_switch
	mkdir -p $(HASH)
