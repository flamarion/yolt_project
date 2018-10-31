# Setup the provider to connnect to Kubernetes cluster
provider "kubernetes" {
  host = "${var.cluster_ip}"

  client_certificate     = "${file(var.client_cert)}"
  client_key             = "${file(var.client_key)}"
  cluster_ca_certificate = "${file(var.ca_crt)}"
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
  count = "${var.instance_count}"

  metadata {
    name = "cm-demo-app-${count.index + 1}"

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

# Create the pod using the image from docker hub
resource "kubernetes_pod" "demo_app" {
  count = "${var.instance_count}"

  metadata {
    name = "pod-demo-app-${count.index + 1}"

    labels {
      app = "${var.demo_app_label}"
    }

    namespace = "${var.demo_app_ns_name}"
  }

  spec {
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

# Create the service to expose the application
resource "kubernetes_service" "demo_app" {
  count = "${var.instance_count}"

  metadata {
    name      = "service-demo-app-${count.index + 1}"
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
