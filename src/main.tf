terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

# Get the repository
data "github_repository" "repo" {
  name = var.repository_name
}

# Add collaborator
resource "github_repository_collaborator" "softservedata" {
  repository = data.github_repository.repo.name
  username   = "softservedata"
  permission = "push"
}

# Create develop branch from main
resource "github_branch" "develop" {
  repository = data.github_repository.repo.name
  branch     = "develop"
}

# Set develop as default branch
resource "github_branch_default" "default" {
  repository = data.github_repository.repo.name
  branch     = github_branch.develop.branch
}

# Branch protection for main branch
resource "github_branch_protection" "main_protection" {
  repository_id = data.github_repository.repo.node_id
  pattern       = "main"

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    required_approving_review_count = 0
    restrict_dismissals             = false
  }

  enforce_admins = false

  depends_on = [github_repository_collaborator.softservedata]
}

# Branch protection for develop branch
resource "github_branch_protection" "develop_protection" {
  repository_id = data.github_repository.repo.node_id
  pattern       = "develop"

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = false
    required_approving_review_count = 2
    restrict_dismissals             = false
  }

  enforce_admins = false

  depends_on = [github_branch.develop, github_repository_collaborator.softservedata]
}

# Add CODEOWNERS file
resource "github_repository_file" "codeowners" {
  repository          = data.github_repository.repo.name
  branch              = "main"
  file                = ".github/CODEOWNERS"
  content             = "* @softservedata\n"
  commit_message      = "Add CODEOWNERS file"
  commit_author       = "Terraform"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

# Add pull request template
resource "github_repository_file" "pr_template" {
  repository          = data.github_repository.repo.name
  branch              = "main"
  file                = ".github/pull_request_template.md"
  content             = <<-EOT
## Describe your changes

## Issue ticket number and link

## Checklist before requesting a review
- [ ] I have performed a self-review of my code
- [ ] If it is a core feature, I have added thorough tests
- [ ] Do we need to implement analytics?
- [ ] Will this be part of a product update? If yes, please write one phrase about this update
EOT
  commit_message      = "Add pull request template"
  commit_author       = "Terraform"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

# Add deploy key
resource "github_repository_deploy_key" "deploy_key" {
  title      = "DEPLOY_KEY"
  repository = data.github_repository.repo.name
  key        = var.deploy_key_public
  read_only  = false
}

# Add Discord webhook
resource "github_repository_webhook" "discord" {
  repository = data.github_repository.repo.name

  configuration {
    url          = var.discord_webhook_url
    content_type = "json"
    insecure_ssl = false
  }

  active = true

  events = ["pull_request"]
}

# Add PAT to repository secrets
resource "github_actions_secret" "pat" {
  repository      = data.github_repository.repo.name
  secret_name     = "PAT"
  plaintext_value = var.pat_token
}

# Add TERRAFORM secret with the Terraform code
resource "github_actions_secret" "terraform_code" {
  repository      = data.github_repository.repo.name
  secret_name     = "TERRAFORM"
  plaintext_value = var.terraform_code
}

