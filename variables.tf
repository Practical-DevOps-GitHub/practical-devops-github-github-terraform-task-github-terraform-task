variable "github_token" {
  description = "GitHub token for authentication"
  type        = string
}

variable "github_owner" {
  description = "GitHub username or organization"
  type        = string
}

variable "discord_webhook" {
  description = "Discord webhook URL"
  type        = string
}

variable "deploy_key" {
  description = "Deploy key for the repository"
  type        = string
}
