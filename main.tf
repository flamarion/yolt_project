provider "kubernetes" {
  host = "https://192.168.99.102:8443"

  client_certificate     = "${file("/Volumes/HD2/flamarion/.minikube/client.crt")}"
  client_key             = "${file("/Volumes/HD2/flamarion/.minikube/client.key")}"
  cluster_ca_certificate = "${file("/Volumes/HD2/flamarion/.minikube/ca.crt")}"
}

resource "kubernetes_pod" "flama_app" {
  metadata {
    name = "flama-app"
    labels {
      app = "flama-app"
    }
  }

  spec {
    container {
      image             = "flamarion/myapp:beta"
      name              = "flama-app"
      image_pull_policy = "Always"

      port {
        container_port = 8080
      }
    }
  }
}

resource "kubernetes_service" "flama_app" {
  metadata {
    name = "flama-app"
    labels {
      app = "flama-app"
    }
  }
  spec {
    selector {
      app = "${kubernetes_pod.flama_app.metadata.0.labels.app}"
    }
    session_affinity = "ClientIP"
    port {
      port = 8080
      target_port = 8080
    }
    type = "ClusterIP"
  }
}
