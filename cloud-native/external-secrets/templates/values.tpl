# Default values for kubernetes-external-secrets.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

# Determines whether the Helm chart or kubernetes-external-secrets
# will handle the ExternalSecret CRD
customResourceManagerDisabled: false

crds:
  # only needed for helm v2, leave this disabled for helm v3
  create: false

# Environment variables to set on deployment pod
env:
  #AWS_REGION: us-west-2
  #AWS_DEFAULT_REGION: us-west-2
  POLLER_INTERVAL_MILLISECONDS: 15000  # Caution, setting this frequency may incur additional charges on some platforms
  WATCH_TIMEOUT: 50000
  LOG_LEVEL: info
  LOG_MESSAGE_KEY: 'message'
  DISABLE_POLLING: true
  # Print logs level as string ("info") rather than integer (30)
  # USE_HUMAN_READABLE_LOG_LEVELS: true
  METRICS_PORT: 3001
  #VAULT_ADDR: http://127.0.0.1:8200
  # Set a role to be used when assuming roles specified in external secret (AWS only)
  # AWS_INTERMEDIATE_ROLE_ARN:
  # GOOGLE_APPLICATION_CREDENTIALS: /app/gcp-creds/gcp-creds.json

# Create environment variables from existing k8s secrets
# envVarsFromSecret:
#  AWS_ACCESS_KEY_ID:
#    secretKeyRef: aws-credentials
#    key: id
#  AWS_SECRET_ACCESS_KEY:
#    secretKeyRef: aws-credentials
#    key: key
#  ALICLOUD_ENDPOINT:
#    secretKeyRef: alicloud-credentials
#    key: endpoint
#  ALICLOUD_ACCESS_KEY_ID:
#    secretKeyRef: alicloud-credentials
#    key: id
#  ALICLOUD_ACCESS_KEY_SECRET:
#    secretKeyRef: alicloud-credentials
#    key: secret
#  AZURE_TENANT_ID:
#    secretKeyRef: azure-credentials
#    key: tenantid
#  AZURE_CLIENT_ID:
#    secretKeyRef: azure-credentials
#    key: clientid
#  AZURE_CLIENT_SECRET:
#    secretKeyRef: azure-credentials
#    key: clientsecret

# Create files from existing k8s secrets
# filesFromSecret:
#   gcp-creds:
#     secret: gcp-creds
#     mountPath: /app/gcp-creds

rbac:
  # Specifies whether RBAC resources should be created
  create: true

serviceAccount:
  # Specifies whether a service account should be created
  create: true
  # Specifies annotations for this service account
  annotations: 
    iam.gke.io/gcp-service-account: ${gcp_service_account}
  
  # The name of the service account to use.
  # If not set and create is true, a name is generated using the fullname template
  name: ${k8_service_account}

replicaCount: 1

image:
  repository: ghcr.io/external-secrets/kubernetes-external-secrets
  tag: 6.1.0
  pullPolicy: IfNotPresent

imagePullSecrets: []

nameOverride: ""
fullnameOverride: ""

podAnnotations: {}
podLabels: {}

priorityClassName: ""

dnsConfig: {}

securityContext:
  runAsNonRoot: true
  # Required for use of IRSA, see https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts-technical-overview.html
  # fsGroup: 65534

resources: {}
  # We usually recommend not to specify default resources and to leave this as a conscious
  # choice for the user. This also increases chances charts run on environments with little
  # resources, such as Minikube. If you do want to specify resources, uncomment the following
  # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  # limits:
  #   cpu: 100m
  #   memory: 128Mi
  # requests:
  #   cpu: 100m
  #   memory: 128Mi

nodeSelector: {}

tolerations: []

affinity: {}

serviceMonitor:
  enabled: false
  interval: "30s"
  namespace:
