terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "k8s_cluster" {
  name   = var.k8s_cluster_name
  region = var.k8s_cluster_region
  version = var.k8s_cluster_version

  node_pool {
    name       = var.k8s_cluster_node_pool_name
    size       = var.k8s_cluster_node_pool_size
    node_count = var.k8s_cluster_node_pool_node_count
}   
}

resource "digitalocean_kubernetes_node_pool" "k8s_node_premium" {
  cluster_id = digitalocean_kubernetes_cluster.k8s_cluster.id
  
  name       = var.k8s_node_pool_premium_name
  size       = var.k8s_node_pool_premium_size
  node_count = var.k8s_node_pool_premium_node_count
}

variable "do_token" {}
variable "k8s_cluster_name" {}
variable "k8s_cluster_region" {}
variable "k8s_cluster_version" {}
variable "k8s_cluster_node_pool_name" {}
variable "k8s_cluster_node_pool_size" {}
variable "k8s_cluster_node_pool_node_count" {}
variable "k8s_node_pool_premium_name" {}
variable "k8s_node_pool_premium_size" {}
variable "k8s_node_pool_premium_node_count" {}
variable "kube_config_file" {}

output "k8s_cluster_endpoint"{
    value = digitalocean_kubernetes_cluster.k8s_cluster.endpoint
}

resource "local_file" "kube_config" {
    content  = digitalocean_kubernetes_cluster.k8s_cluster.kube_config.0.raw_config
    filename = var.kube_config_file 
}
