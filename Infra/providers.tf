provider "aws" {
  region = "eu-west-1"
  profile = "bennie@rgt"
  default_tags {
    tags = {
      owner           = "benjamin.nii.sowah.gh2"
      bootcamp        = "ghana2"
      expiration_date = "04-04-24"
    }
  }
}

terraform {
  backend "s3" {
    profile = "bennie@rgt"
    bucket = "gh-bc2-tfstate"
    key = "bennie/portfolio-test.tfstate"
    region     = "ap-south-1"
    dynamodb_table = "bennie-tfstatefile-lock"
    encrypt = true
  }
}


terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.3"
}



# data "aws_eks_cluster" "this" {
#   name = "${var.project}-cluster"
#   # depends_on = [
#   #   aws_eks_cluster.this
#   # ]
# }

# provider "helm" {
#   kubernetes {
#     host                   = data.aws_eks_cluster.this.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.this.name]
#       command     = "aws"
#     }
#   }
# }

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.this.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)

#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.this.name]
#     command     = "aws"
#   }
# }

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}