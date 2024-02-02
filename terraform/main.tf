terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "ow-projects"

    workspaces {
      name = "jamf-homework"
    }
  }
}
