provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

resource "kubernetes_namespace" "qa" {
  metadata {
    name = var.envs["qa"]
  }
}

resource "kubernetes_namespace" "staging" {
  metadata {
    name = var.envs["staging"]
  }
}
