resource "helm_release" "cert_manager" {
  provider         = helm
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.cert-manager-version
  namespace        = "cert-manager"
  create_namespace = var.create_certmanager_namespace ? "false" : "true"
  values           = [templatefile("${path.module}/templates/values.yaml", {})]
  lint             = true
  cleanup_on_fail  = true

  dynamic "set" {
    for_each = var.certmanager_value_overrides
    iterator = override
    content {
      name  = override.key
      value = override.value
    }
  }
  depends_on = [
    kubernetes_namespace.cert_manager
  ]
}

resource "kubernetes_namespace" "cert_manager" {
  provider = kubernetes
  count    = var.create_certmanager_namespace ? 1 : 0
  metadata {
    annotations = {
      name = "cert-namanger"
    }

    labels = {
      application = "cert-manager"
      name        = "cert-manager"
    }

    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "ingress" {
  provider = kubernetes
  count    = var.create_ingress_namespace ? 1 : 0
  metadata {
    annotations = {
      name = "ingress"
    }

    labels = {
      application = "ingress"
      name        = "ingress"
    }

    name = "ingress"
  }
}



resource "helm_release" "manifests" {
  provider         = helm
  name             = "cert-manager-manifests"
  chart            = "${path.module}/manifests"
  version          = "1.0.1"
  namespace        = "ingress"
  create_namespace = var.create_ingress_namespace ? "false" : "true"
  force_update     = true
  lint             = true
  cleanup_on_fail  = true

  dynamic "set" {
    for_each = local.manifest_map
    content {
      name  = set.key
      value = set.value
    }
  }


  depends_on = [
    helm_release.cert_manager
  ]
}
