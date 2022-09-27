terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "s3-momo-terraform-state"
    key        = "terraform.tfstate"
    region     = "us-east-1"
    access_key = "YCAJEmiuyZSWeDe9jOdn9LH8y"
    secret_key = "YCOsyFZttLkeHNnd1Xb_4YPtnmdipt2O5UtAbvqJ"
    skip_credentials_validation = true
    force_path_style = true
  }
}
resource "yandex_kubernetes_cluster" "kuber-main" {
  network_id = yandex_vpc_network.network-main.id
  master {
    zonal {
      zone      = yandex_vpc_subnet.subnet-main.zone
      subnet_id = yandex_vpc_subnet.subnet-main.id
  }
    public_ip = true
}
service_account_id      = yandex_iam_service_account.kuber-admin.id
node_service_account_id = yandex_iam_service_account.kuber-admin.id
    depends_on = [
    yandex_resourcemanager_folder_iam_binding.editor,
    yandex_resourcemanager_folder_iam_binding.images-puller
    ]
}
resource "yandex_vpc_network" "network-main" { name = "main-network" }
resource "yandex_vpc_subnet" "subnet-main" {
  v4_cidr_blocks = ["10.22.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-main.id
}
resource "yandex_iam_service_account" "kuber-admin" {
  name        = "kuber-admin"
  description = "admin cluster kubernetes"
}
resource "yandex_resourcemanager_folder_iam_binding" "editor" {
# Service account to be assigned "editor" role.
  folder_id = var.folder_id
  role      = "editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.kuber-admin.id}"
  ]
}
resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
# Service account to be assigned "container-registry.images.puller" role.
folder_id = var.folder_id
role      = "container-registry.images.puller"
members   = [
    "serviceAccount:${yandex_iam_service_account.kuber-admin.id}"
  ]
}
resource "yandex_kubernetes_node_group" "main-node-group" {
  cluster_id  = "${yandex_kubernetes_cluster.kuber-main.id}"
  name        = "main-node-group"
  description = "description"
  version     = "1.21"
  labels = {
    "key" = "value"
  }
  instance_template {
    platform_id = "standard-v2"
    network_interface {
      nat                = true
      subnet_ids         = ["${yandex_vpc_subnet.subnet-main.id}"]
    }
    resources {
      memory = 4
      cores  = 2
    }
    boot_disk {
      type = "network-hdd"
      size = 64
    }
    scheduling_policy {
      preemptible = false
    }
    container_runtime {
      type = "containerd"
    }
  }
  scale_policy {
    fixed_scale {
      size = 1
    }
  }
  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }
  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }
    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}