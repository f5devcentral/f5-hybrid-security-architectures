# temporary file which is needed for site cleanup
resource "volterra_site_state" "eks-site" {
  count = var.hybrid_genai ? 1 : 0
  name  = var.eks_site_name
  state = "DECOMMISSIONING"
  when  = "delete"
}

resource "volterra_registration_approval" "eks-k8s-ce" {
  count = var.hybrid_genai ? 1 : 0
  depends_on      =  [volterra_site_state.eks-site]
  cluster_name  = var.eks_site_name
  cluster_size  = 1
  retry = 5
  wait_time = 150
  hostname = "vp-manager-0"
}

resource "volterra_site_state" "gke-site" {
  count = var.hybrid_genai ? 1 : 0
  name  = var.gke_site_name
  state = "DECOMMISSIONING"
  when  = "delete"
}

resource "volterra_registration_approval" "gke-k8s-ce" {
  count = var.hybrid_genai ? 1 : 0
  depends_on      =  [volterra_site_state.gke-site]
  cluster_name  = var.gke_site_name
  cluster_size  = 1
  retry = 5
  wait_time = 150
  hostname = "vp-manager-0"
}

