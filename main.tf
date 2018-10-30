provider "kubernetes" {
  host = "https://192.168.99.102:8443"

  client_certificate     = "${file("/Volumes/HD2/flamarion/.minikube/client.crt")}"
  client_key             = "${file("/Volumes/HD2/flamarion/.minikube/client.key")}"
  cluster_ca_certificate = "${file("/Volumes/HD2/flamarion/.minikube/ca.crt")}"
}

variable "instance_count" {
  description = "Instance count"
  default = 1
}

variable "demo_app_label" {
  description = "Label"
  default = "demo-app"
}

variable "demo_app_ns_name" {
  description = "Namespace name"
  default = "demo-app-ns"
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
    name = "cm-${count.index}"
    labels {
      app = "${var.demo_app_label}"
    }
    namespace = "${var.demo_app_ns_name}"
  }

  data {
    app_name = "YOLT-Config-Map-Kubernetes"
  }
}

resource "kubernetes_pod" "demo_app" {
  count = "${var.instance_count}"

  metadata {
    name = "pod-${count.index}"
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
    }
  }
}

resource "kubernetes_service" "demo_app" {
  count = "${var.instance_count}"

  metadata {
    name = "service-${count.index}"
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
