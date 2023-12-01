#Proveedor de azure
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.80.0"
    }
  
  }
}

provider "azurerm" {
  features{}
}


resource "azurerm_kubernetes_cluster" "prueba" {
  name                = "prueba-aks"
  location            = "North Europe"
  resource_group_name = "FCT2023"
  dns_prefix          = "pruebaks"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_B2pls_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}


provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "argocd" {
  name  = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "4.9.7"
  create_namespace = true

  values = [
    file("ArgoCD/application.yaml")
  ]
}


#Ejecutar un terraform plan -out aks.tfplan
#Una vez ejecutado, proceder a hacer terraform apply aks.tfplan
