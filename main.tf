# Setup the provider to connnect to Kubernetes cluster
provider "kubernetes" {
  config_context_auth_info = "minikube"
  config_context_cluster   = "minikube"
}

# Create the NameSpace where the application will run
resource "kubernetes_namespace" "demo_app" {
  metadata {
    name = "${var.demo_app_ns_name}"

    labels {
      app = "${var.demo_app_label}"
    }
  }
}

# Create the ConfigMap inside the NameSpace
resource "kubernetes_config_map" "demo_app" {
  metadata {
    name = "cm-demo-app"

    labels {
      app = "${var.demo_app_label}"
    }

    namespace = "${var.demo_app_ns_name}"
  }

  data {
    app_name = "YOLT Demo App - ConfigMap"
  }

  depends_on = ["kubernetes_namespace.demo_app"]
}

# Create the Replication Controller

resource "kubernetes_replication_controller" "demo_app" {
  metadata {
    name      = "pod-demo-app"
    namespace = "${var.demo_app_ns_name}"

    labels {
      app = "${var.demo_app_label}"
    }
  }

  spec {
    replicas = "${var.replica_count}"

    selector {
      app = "${var.demo_app_label}"
    }

    template {
      container {
        image             = "flamarion/myapp:beta"
        name              = "demo-app"
        image_pull_policy = "Always"

        port {
          container_port = 8080
        }

        env_from = [{
          config_map_ref {
            name     = "${kubernetes_config_map.demo_app.metadata.0.name}"
            optional = false
          }

          prefix = "FROM_CM"
        }]
      }
    }
  }
}

# Create the service to expose the application
resource "kubernetes_service" "demo_app" {
  metadata {
    name      = "service-demo-app"
    namespace = "${var.demo_app_ns_name}"

    labels {
      app = "${var.demo_app_label}"
    }
  }

  spec {
    selector {
      app = "${var.demo_app_label}"
    }

    session_affinity = "ClientIP"

    port {
      port        = 8080
      target_port = 8080
    }

    type = "NodePort"
  }
}

output "service_api" {
  value = "${kubernetes_service.demo_app.metadata.0.self_link}"
}
