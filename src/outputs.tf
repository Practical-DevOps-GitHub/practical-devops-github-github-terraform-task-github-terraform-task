output "repository_name" {
  description = "The name of the configured repository"
  value       = data.github_repository.repo.name
}

output "repository_url" {
  description = "The URL of the configured repository"
  value       = data.github_repository.repo.html_url
}

output "default_branch" {
  description = "The default branch of the repository"
  value       = github_branch_default.default.branch
}

output "collaborator_added" {
  description = "Collaborator username added to the repository"
  value       = github_repository_collaborator.softservedata.username
}

output "deploy_key_id" {
  description = "ID of the deploy key"
  value       = github_repository_deploy_key.deploy_key.id
}

output "webhook_url" {
  description = "Discord webhook URL (masked)"
  value       = "Configured"
  sensitive   = true
}

