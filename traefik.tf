# Traefik deployment
resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }
}

resource "helm_release" "traefik" {
  depends_on = [
    kubernetes_namespace.traefik
  ]

  name = "traefik"
  namespace = "traefik"

  repository = "https://helm.traefik.io/traefik"
  chart = "traefik"

  # Set Traefik as the default Ingress Controller
  set {
    name = "ingressClass.enabled"
    value = "true"
  }
  set {
    name = "ingressClass.isDefaultClass"
    value = "true"
  }
  # Default redirect
  set {
    name = "ports.web.redirectTo"
    value = "websecure"
  }
  # Enable TLS on Websecure
  set {
    name = "ports.websecure.tls.enabled"
    value = "true"
  }
}