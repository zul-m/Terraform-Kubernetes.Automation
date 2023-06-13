# Kubernetes Cluster
data "civo_size" "xsmall" {
  filter {
    key = "name"
    values = ["g4s.kube.xsmall"]
    match_by = "re"
  }
}

resource "civo_kubernetes_cluster" "k8s_demo_1" {
  name = "k8s_demo_1"
  applications = ""
  num_target_nodes = 2
  target_nodes_size = element(data.civo_size.xsmall.sizes, 0).name
  firewall_id = civo_firewall.fw_demo_1.id
}

resource "civo_firewall" "fw_demo_1" {
  name = "fw_demo_1"

  create_default_rules = false
}

resource "civo_firewall" "kubernetes_http" {
  firewall_id = civo_firewall.fw_demo_1.id
  protocol = "tcp"
  start_port = "80"
  end_port = "80"
  cidr = ["0.0.0.0/0"]
  direction = "ingress"
  action = "allow"
  label = "kubernetes_http"
}

resource "civo_firewall" "kubernetes_https" {
  firewall_id = civo_firewall.fw_demo_1.id
  protocol = "tcp"
  start_port = "443"
  end_port = "443"
  cidr = ["0.0.0.0/0"]
  direction = "ingress"
  action = "allow"
  label = "kubernetes_https"
}

resource "civo_firewall" "kubernetes_api" {
  firewall_id = civo_firewall.fw_demo_1.id
  protocol = "tcp"
  start_port = "6443"
  end_port = "6443"
  cidr = ["0.0.0.0/0"]
  direction = "ingress"
  action = "allow"
  label = "kubernetes_api"
}
