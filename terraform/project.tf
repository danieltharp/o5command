resource "digitalocean_project" "project" {
  name        = "o5command"
  description = "Project to contain all o5command resources"
  purpose     = "Web Application"
  environment = "Production"
  resources   = [

  ]
}