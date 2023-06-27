resource "kubernetes_namespace" "nginx1" {
  depends_on = [
    time_sleep.wait_for_kubernetes
  ]

  metadata {
    name = "nginx1"
  }
}

resource "kubernetes_deployment" "nginx1" {
  depends_on = [
    kubernetes_namespace.nginx1
  ]

  metadata {
    name = "nginx1"
    namespace = "nginx1"
    labels = {
      app = "nginx1"
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx1"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx1"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name = "nginx"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}