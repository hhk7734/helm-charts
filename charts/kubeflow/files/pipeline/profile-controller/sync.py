# Copyright 2020-2021 The Kubeflow Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import base64
import json
import os
from http.server import BaseHTTPRequestHandler, HTTPServer


def main():
    settings = get_settings_from_env()
    server = server_factory(**settings)
    server.serve_forever()


def get_settings_from_env(
    controller_port=None,
    visualization_server_image=None,
    frontend_image=None,
    visualization_server_tag=None,
    frontend_tag=None,
    disable_istio_sidecar=None,
    minio_access_key=None,
    minio_secret_key=None,
    kubeflow_namespace=None,
    kfp_default_pipeline_root=None,
    pipeline_serviceaccount=None,
):
    """
    Returns a dict of settings from environment variables relevant to the controller

    Environment settings can be overridden by passing them here as arguments.

    Settings are pulled from the all-caps version of the setting name.  The
    following defaults are used if those environment variables are not set
    to enable backwards compatibility with previous versions of this script:
        visualization_server_image: gcr.io/ml-pipeline/visualization-server
        visualization_server_tag: value of KFP_VERSION environment variable
        frontend_image: gcr.io/ml-pipeline/frontend
        frontend_tag: value of KFP_VERSION environment variable
        disable_istio_sidecar: Required (no default)
        minio_access_key: Required (no default)
        minio_secret_key: Required (no default)
    """
    settings = dict()
    settings["controller_port"] = controller_port or os.environ.get(
        "CONTROLLER_PORT", "8080"
    )

    settings[
        "visualization_server_image"
    ] = visualization_server_image or os.environ.get(
        "VISUALIZATION_SERVER_IMAGE", "gcr.io/ml-pipeline/visualization-server"
    )

    settings["frontend_image"] = frontend_image or os.environ.get(
        "FRONTEND_IMAGE", "gcr.io/ml-pipeline/frontend"
    )

    # Look for specific tags for each image first, falling back to
    # previously used KFP_VERSION environment variable for backwards
    # compatibility
    settings["visualization_server_tag"] = (
        visualization_server_tag
        or os.environ.get("VISUALIZATION_SERVER_TAG")
        or os.environ["KFP_VERSION"]
    )

    settings["frontend_tag"] = (
        frontend_tag or os.environ.get("FRONTEND_TAG") or os.environ["KFP_VERSION"]
    )

    settings["disable_istio_sidecar"] = (
        disable_istio_sidecar
        if disable_istio_sidecar is not None
        else os.environ.get("DISABLE_ISTIO_SIDECAR") == "true"
    )

    settings["object_store_host"] = os.environ.get("OBJECT_STORE_HOST")
    settings["object_store_region"] = os.environ.get("OBJECT_STORE_REGION")
    settings["object_store_bucket"] = os.environ.get("OBJECT_STORE_BUCKET")
    settings["object_store_key_format"] = os.environ.get("OBJECT_STORE_KEY_FORMAT")

    settings["minio_access_key"] = minio_access_key or base64.b64encode(
        bytes(os.environ.get("MINIO_ACCESS_KEY"), "utf-8")
    ).decode("utf-8")

    settings["minio_secret_key"] = minio_secret_key or base64.b64encode(
        bytes(os.environ.get("MINIO_SECRET_KEY"), "utf-8")
    ).decode("utf-8")

    settings["kubeflow_namespace"] = kubeflow_namespace or os.environ.get(
        "POD_NAMESPACE", "kubeflow"
    )

    # KFP_DEFAULT_PIPELINE_ROOT is optional
    settings["kfp_default_pipeline_root"] = kfp_default_pipeline_root or os.environ.get(
        "KFP_DEFAULT_PIPELINE_ROOT"
    )

    settings["pipeline_serviceaccount"] = pipeline_serviceaccount or os.environ.get(
        "PIPELINE_SERVICEACCOUNT", "ml-pipeline"
    )

    return settings


def server_factory(
    visualization_server_image,
    visualization_server_tag,
    frontend_image,
    frontend_tag,
    disable_istio_sidecar,
    object_store_host,
    object_store_region,
    object_store_bucket,
    object_store_key_format,
    minio_access_key,
    minio_secret_key,
    kubeflow_namespace,
    pipeline_serviceaccount,
    kfp_default_pipeline_root=None,
    url="",
    controller_port=8080,
):
    """
    Returns an HTTPServer populated with Handler with customized settings
    """

    class Controller(BaseHTTPRequestHandler):
        def _get_metadata_grpc(self, namespace):
            return [
                {
                    "apiVersion": "v1",
                    "kind": "ConfigMap",
                    "metadata": {
                        "name": "metadata-grpc-configmap",
                        "namespace": namespace,
                    },
                    "data": {
                        "METADATA_GRPC_SERVICE_HOST": f"metadata-grpc-service.{kubeflow_namespace}",
                        "METADATA_GRPC_SERVICE_PORT": "8080",
                    },
                }
            ]

        def _get_visualizationserver(self, namespace):
            return [
                {
                    "apiVersion": "apps/v1",
                    "kind": "Deployment",
                    "metadata": {
                        "labels": {"app": "ml-pipeline-visualizationserver"},
                        "name": "ml-pipeline-visualizationserver",
                        "namespace": namespace,
                    },
                    "spec": {
                        "selector": {
                            "matchLabels": {"app": "ml-pipeline-visualizationserver"},
                        },
                        "template": {
                            "metadata": {
                                "labels": {"app": "ml-pipeline-visualizationserver"},
                                "annotations": disable_istio_sidecar
                                and {"sidecar.istio.io/inject": "false"}
                                or {},
                            },
                            "spec": {
                                "containers": [
                                    {
                                        "image": f"{visualization_server_image}:{visualization_server_tag}",
                                        "imagePullPolicy": "IfNotPresent",
                                        "name": "ml-pipeline-visualizationserver",
                                        "ports": [{"containerPort": 8888}],
                                        "resources": {
                                            "requests": {
                                                "cpu": "50m",
                                                "memory": "200Mi",
                                            },
                                            "limits": {"cpu": "500m", "memory": "1Gi"},
                                        },
                                    }
                                ],
                                "serviceAccountName": "default-editor",
                            },
                        },
                    },
                },
                {
                    "apiVersion": "networking.istio.io/v1alpha3",
                    "kind": "DestinationRule",
                    "metadata": {
                        "name": "ml-pipeline-visualizationserver",
                        "namespace": namespace,
                    },
                    "spec": {
                        "host": "ml-pipeline-visualizationserver",
                        "trafficPolicy": {"tls": {"mode": "ISTIO_MUTUAL"}},
                    },
                },
                {
                    "apiVersion": "security.istio.io/v1beta1",
                    "kind": "AuthorizationPolicy",
                    "metadata": {
                        "name": "ml-pipeline-visualizationserver",
                        "namespace": namespace,
                    },
                    "spec": {
                        "selector": {
                            "matchLabels": {"app": "ml-pipeline-visualizationserver"}
                        },
                        "rules": [
                            {
                                "from": [
                                    {
                                        "source": {
                                            "principals": [
                                                f"cluster.local/ns/{kubeflow_namespace}/sa/{pipeline_serviceaccount}"
                                            ]
                                        }
                                    }
                                ]
                            }
                        ],
                    },
                },
                {
                    "apiVersion": "v1",
                    "kind": "Service",
                    "metadata": {
                        "name": "ml-pipeline-visualizationserver",
                        "namespace": namespace,
                    },
                    "spec": {
                        "ports": [
                            {
                                "name": "http",
                                "port": 8888,
                                "protocol": "TCP",
                                "targetPort": 8888,
                            }
                        ],
                        "selector": {
                            "app": "ml-pipeline-visualizationserver",
                        },
                    },
                },
            ]

        def _get_pipeline_ui(self, namespace):
            deployment_env = [
                {
                    "name": "AWS_ACCESS_KEY_ID"
                    if object_store_host == "s3.amazonaws.com"
                    else "MINIO_ACCESS_KEY",
                    "valueFrom": {
                        "secretKeyRef": {
                            "key": "accesskey",
                            "name": "mlpipeline-minio-artifact",
                        }
                    },
                },
                {
                    "name": "AWS_SECRET_ACCESS_KEY"
                    if object_store_host == "s3.amazonaws.com"
                    else "MINIO_SECRET_KEY",
                    "valueFrom": {
                        "secretKeyRef": {
                            "key": "secretkey",
                            "name": "mlpipeline-minio-artifact",
                        }
                    },
                },
            ]
            if object_store_region:
                deployment_env.append(
                    {
                        "name": "AWS_REGION",
                        "value": object_store_region,
                    }
                )

            return [
                {
                    "apiVersion": "apps/v1",
                    "kind": "Deployment",
                    "metadata": {
                        "labels": {"app": "ml-pipeline-ui-artifact"},
                        "name": "ml-pipeline-ui-artifact",
                        "namespace": namespace,
                    },
                    "spec": {
                        "selector": {"matchLabels": {"app": "ml-pipeline-ui-artifact"}},
                        "template": {
                            "metadata": {
                                "labels": {"app": "ml-pipeline-ui-artifact"},
                                "annotations": disable_istio_sidecar
                                and {"sidecar.istio.io/inject": "false"}
                                or {},
                            },
                            "spec": {
                                "containers": [
                                    {
                                        "name": "ml-pipeline-ui-artifact",
                                        "image": f"{frontend_image}:{frontend_tag}",
                                        "imagePullPolicy": "IfNotPresent",
                                        "ports": [{"containerPort": 3000}],
                                        "env": deployment_env,
                                        "resources": {
                                            "requests": {
                                                "cpu": "10m",
                                                "memory": "70Mi",
                                            },
                                            "limits": {
                                                "cpu": "100m",
                                                "memory": "500Mi",
                                            },
                                        },
                                    }
                                ],
                                "serviceAccountName": "default-editor",
                            },
                        },
                    },
                },
                {
                    "apiVersion": "v1",
                    "kind": "Service",
                    "metadata": {
                        "name": "ml-pipeline-ui-artifact",
                        "namespace": namespace,
                        "labels": {"app": "ml-pipeline-ui-artifact"},
                    },
                    "spec": {
                        "ports": [
                            {
                                "name": "http",  # name is required to let istio understand request protocol
                                "port": 80,
                                "protocol": "TCP",
                                "targetPort": 3000,
                            }
                        ],
                        "selector": {"app": "ml-pipeline-ui-artifact"},
                    },
                },
            ]

        def _get_artifact(self, namespace):
            return [
                {
                    "apiVersion": "v1",
                    "kind": "ConfigMap",
                    "metadata": {
                        "name": "artifact-repositories",
                        "namespace": namespace,
                        "labels": {
                            "application-crd-id": "kubeflow-pipelines",
                        },
                        "annotations": {
                            "workflows.argoproj.io/default-artifact-repository": "artifactRepository",
                        },
                    },
                    "data": {
                        "artifactRepository": f"""
archiveLogs: true
s3:
  endpoint: {object_store_host}
  bucket: {object_store_bucket}
  {f"region: {object_store_region}" if object_store_region else ""}
  keyFormat: {object_store_key_format}
  insecure: true
  accessKeySecret:
    name: mlpipeline-minio-artifact
    key: accesskey
  secretKeySecret:
    name: mlpipeline-minio-artifact
    key: secretkey
"""
                    },
                },
            ]

        def sync(self, object_, attachments):
            # object is a namespace
            namespace = object_.get("metadata", {}).get("name")

            desired_configmap_count = 2
            desired_resources = []
            if kfp_default_pipeline_root:
                desired_configmap_count += 1
                desired_resources += [
                    {
                        "apiVersion": "v1",
                        "kind": "ConfigMap",
                        "metadata": {
                            "name": "kfp-launcher",
                            "namespace": namespace,
                        },
                        "data": {
                            "defaultPipelineRoot": kfp_default_pipeline_root,
                        },
                    }
                ]

            # Compute status based on observed state.
            desired_status = {
                "kubeflow-pipelines-ready": len(attachments["Secret.v1"]) == 1
                and len(attachments["ConfigMap.v1"]) == desired_configmap_count
                and len(attachments["Deployment.apps/v1"]) == 2
                and len(attachments["Service.v1"]) == 2
                and len(attachments["DestinationRule.networking.istio.io/v1alpha3"])
                == 1
                and len(attachments["AuthorizationPolicy.security.istio.io/v1beta1"])
                == 1
                and "True"
                or "False"
            }

            # Generate the desired child object(s).
            desired_resources += self._get_artifact(namespace)

            desired_resources += self._get_metadata_grpc(namespace)

            desired_resources += self._get_visualizationserver(namespace)

            desired_resources += self._get_pipeline_ui(namespace)

            print("Received request:\n", json.dumps(object_, sort_keys=True))
            print(
                "Desired resources except secrets:\n",
                json.dumps(desired_resources, sort_keys=True),
            )
            # Moved after the print argument because this is sensitive data.
            desired_resources.append(
                {
                    "apiVersion": "v1",
                    "kind": "Secret",
                    "metadata": {
                        "name": "mlpipeline-minio-artifact",
                        "namespace": namespace,
                    },
                    "data": {
                        "accesskey": minio_access_key,
                        "secretkey": minio_secret_key,
                    },
                }
            )

            return {"status": desired_status, "attachments": desired_resources}

        def do_POST(self):
            # Serve the sync() function as a JSON webhook.
            observed = json.loads(
                self.rfile.read(int(self.headers.get("content-length")))
            )
            desired = self.sync(observed["object"], observed["attachments"])

            self.send_response(200)
            self.send_header("Content-type", "application/json")
            self.end_headers()
            self.wfile.write(bytes(json.dumps(desired), "utf-8"))

    return HTTPServer((url, int(controller_port)), Controller)


if __name__ == "__main__":
    main()
