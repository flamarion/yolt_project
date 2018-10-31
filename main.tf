variable "cluster_ip" {
  description = "Kubernetes cluster IP"
}

variable "client_cert" {
  description = "Client Certificate"
}

variable "client_key" {
  description = "Client Key"
}

variable "ca_crt" {
  description = "CA Cert"
}

variable "instance_count" {
  description = "Instance count"
  default     = 1
}

variable "demo_app_label" {
  description = "Label"
  default     = "demo-app"
}

variable "demo_app_ns_name" {
  description = "Namespace name"
  default     = "demo-app-ns"
}

provider "kubernetes" {
  host = "${var.cluster_ip}"

  client_certificate     = "${file(var.client_cert)}"
  client_key             = "${file(var.client_key)}"
  cluster_ca_certificate = "${file(var.ca_crt)}"
}

resource "kubernetes_namespace" "demo_app" {
  metadata {
    name = "${var.demo_app_ns_name}"

    labels {
      app = "${var.demo_app_label}"
    }
  }
}

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
}

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

    type = "ClusterIP"
  }
}
