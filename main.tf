terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.2"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = "Practical-DevOps-GitHub"   # the org that owns the repo
}

variable "github_token" {
  description = "Your Github PAT"
  type        = string
  sensitive   = true
}

locals {
  repo_name = "github-terraform-task-harturicko"   # short name only
}

data "github_repository" "repo" {
  full_name = "Practical-DevOps-GitHub/${local.repo_name}"  # full_name for data source
}

resource "github_repository_collaborator" "repo_collaborator" {
  repository = local.repo_name   # short name — owner comes from provider
  username   = "softservedata"
  permission = "admin"
}

resource "github_branch" "develop" {
  repository = local.repo_name
  branch     = "develop"
}

resource "github_branch_default" "default" {
  repository = local.repo_name
  branch     = github_branch.develop.branch
}

resource "github_repository_file" "codeowners_main" {
  repository          = local.repo_name
  branch              = "main"
  file                = ".github/CODEOWNERS"
  content             = "* @softservedata\n"
  overwrite_on_create = true
}

resource "github_repository_file" "codeowners_develop" {
  repository          = local.repo_name
  branch              = github_branch.develop.branch
  file                = ".github/CODEOWNERS"
  content             = "* @softservedata\n"
  overwrite_on_create = true
  depends_on          = [github_branch.develop]
}

resource "github_branch_protection" "main_protection" {
  repository_id  = data.github_repository.repo.node_id  # node_id is fine here
  pattern        = "main"
  enforce_admins = true

  required_pull_request_reviews {
    required_approving_review_count = 1
    require_code_owner_reviews      = true
    dismiss_stale_reviews           = true
  }
  depends_on = [github_repository_file.codeowners_main]
}

resource "github_branch_protection" "develop_protection" {
  repository_id  = data.github_repository.repo.node_id
  pattern        = "develop"
  enforce_admins = true

  required_pull_request_reviews {
    required_approving_review_count = 2
    require_code_owner_reviews      = true
    dismiss_stale_reviews           = true
  }
  depends_on = [github_repository_file.codeowners_develop]
}


resource "github_actions_secret" "terraform_secret" {
  repository      = local.repo_name
  secret_name     = "TERRAFORM"
  plaintext_value = file("${path.module}/demo.tf")  # reads your .tf file content
}

