variable "github_token" {
  description = "The GitHub personal access token for authentication"
  type        = string
}

variable "github_owner" {
  description = "The GitHub organization or username that owns the repository"
  type        = string
}

variable "discord_webhook" {
  description = "Discord webhook URL for notifications"
  type        = string
}
