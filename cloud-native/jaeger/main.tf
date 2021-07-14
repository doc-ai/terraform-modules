###################### JAEGER
resource "helm_release" "jaeger" {
  name             = "jaeger"
  repository       = "https://jaegertracing.github.io/helm-charts"
  chart            = "jaegertracing/jaeger"
  version          = "0.46.4"
  namespace        = "jaeger"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true

  data = {
    "elasticsearch-password" = var.elasticsearch_password
  }

  values = [
    templatefile("./${path.module}/templates/jaeger.values.yaml", {})
  ]
}
