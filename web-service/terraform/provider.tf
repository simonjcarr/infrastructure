variable "hcloud_sandpit_token" {}
provider "hcloud" {
  token = var.hcloud_sandpit_token
}
