terraform {
  required_version = ">= 1.5.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

variable "pat" {
  description = "GitHub personal access token classic"
  type        = string
  sensitive   = true

  default = "ghp_000000000000000000000000000000000000"
}

variable "discord_webhook_url" {
  description = "Discord webhook URL without /github suffix"
  type        = string
  sensitive   = true

  default = "https://discord.com/api/webhooks/000000000000000000/placeholder"
}

locals {
  owner      = "Practical-DevOps-GitHub"
  repository = "github-terraform-task-StephanHorbach"
}

provider "github" {
  owner = local.owner
}

resource "github_repository_collaborator" "softservedata" {
  repository = local.repository
  username   = "softservedata"
  permission = "push"
}

resource "github_branch" "develop" {
  repository    = local.repository
  branch        = "develop"
  source_branch = "main"
}

resource "github_branch_default" "develop" {
  repository = local.repository
  branch     = github_branch.develop.branch
}

resource "github_repository_file" "codeowners" {
  repository          = local.repository
  branch              = "main"
  file                = ".github/CODEOWNERS"
  content             = "* @softservedata\n"
  commit_message      = "Add CODEOWNERS"
  overwrite_on_create = true

  depends_on = [
    github_branch.develop,
    github_repository_collaborator.softservedata
  ]
}

resource "github_repository_file" "pull_request_template" {
  repository = local.repository
  branch     = "main"
  file       = ".github/pull_request_template.md"

  content = <<-EOT
    ## Describe your changes

    ## Issue ticket number and link

    ## Checklist before requesting a review
    - [ ] I have performed a self-review of my code
    - [ ] If it is a core feature, I have added thorough tests
    - [ ] Do we need to implement analytics?
    - [ ] Will this be part of a product update? If yes, please write one phrase about this update
  EOT

  commit_message      = "Add pull request template"
  overwrite_on_create = true

  depends_on = [github_branch.develop]
}

resource "github_branch_protection" "develop" {
  repository_id  = local.repository
  pattern        = "develop"
  enforce_admins = true

  allows_deletions    = false
  allows_force_pushes = false

  required_pull_request_reviews {
    required_approving_review_count = 2
    dismiss_stale_reviews           = true
  }

  depends_on = [github_branch.develop]
}

resource "github_branch_protection" "main" {
  repository_id  = local.repository
  pattern        = "main"
  enforce_admins = true

  allows_deletions    = false
  allows_force_pushes = false

  required_pull_request_reviews {
    required_approving_review_count = 0
    require_code_owner_reviews      = true
    dismiss_stale_reviews           = true
  }

  depends_on = [
    github_repository_file.codeowners,
    github_repository_file.pull_request_template
  ]
}

resource "tls_private_key" "deploy_key" {
  algorithm = "ED25519"
}

resource "github_repository_deploy_key" "deploy_key" {
  title      = "DEPLOY_KEY"
  repository = local.repository
  key        = tls_private_key.deploy_key.public_key_openssh
  read_only  = true
}

resource "github_repository_webhook" "discord" {
  repository = local.repository
  events     = ["pull_request"]
  active     = true

  configuration {
    url          = format("%s/github", var.discord_webhook_url)
    content_type = "json"
    insecure_ssl = false
  }
}

resource "github_actions_secret" "pat" {
  repository  = local.repository
  secret_name = "PAT"
  value       = var.pat
}
