variable "github_token" {
  description = "GitHub Personal Access Token with repo and admin:org permissions"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub repository owner (username or organization)"
  type        = string
}

variable "repository_name" {
  description = "Name of the GitHub repository"
  type        = string
}

variable "deploy_key_public" {
  description = "Public SSH key for deploy key"
  type        = string
  sensitive   = true
}

variable "discord_webhook_url" {
  description = "Discord webhook URL for pull request notifications"
  type        = string
  sensitive   = true
}

variable "pat_token" {
  description = "Personal Access Token with full control of private repositories and orgs"
  type        = string
  sensitive   = true
}

variable "terraform_code" {
  description = "The Terraform code to be stored in repository secret"
  type        = string
  sensitive   = true
}

