variable "app_name" {}
variable "environment" {}

variable "vpc_cidr" {
  default = "172.31.0.0/16"
}

variable "subnet_cidrs" {
  default = {
    "private" = [
      "172.31.1.0/24",
      "172.31.2.0/24",
      "172.31.3.0/24"
    ],
    "public" = [
      "172.31.101.0/24",
      "172.31.102.0/24",
      "172.31.103.0/24"
    ]
  }
  type = map
}

variable "az_ids" {
  default = [
    "use1-az1",
    "use1-az2",
    "use1-az3",
  ]
  type = list(string)
}
