resource "helm_release" "ambassador" {
  name             = "ambassador"
  repository       = "https://getambassador.io"
  chart            = "ambassador"
  version          = "6.6.0"
  namespace        = "ingress"
  create_namespace = var.create_namespace ? "false" : "true"
  force_update     = true
  lint             = true

  values = [file("${path.module}/templates/values.yaml")]
  dynamic "set" {
    for_each = var.ambassador_overrides
    content {
      name  = set.key
      value = set.value
    }
  }
  depends_on = [kubernetes_namespace.ingress]
}

resource "kubernetes_namespace" "ingress" {
  count = var.create_namespace ? 1 : 0
  metadata {
    annotations = {
      name = "ingress"
    }

    labels = {
      application = "ambassador"
    }
    name = "ingress"
  }
}


resource "helm_release" "manifests" {
  name         = "ambassador-manifests"
  chart        = "${path.module}/manifests"
  version      = "1.1.0"
  namespace    = "ingress"
  force_update = true
  lint         = true

  dynamic "set" {
    for_each = local.tls_contexts
    content {
      name  = "tls_contexts.${set.key}"
      value = set.value
    }
  }
  depends_on = [
    helm_release.ambassador
  ]
}