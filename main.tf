provider "github" {
  token = var.github_token
}

resource "github_repository" "repo" {
  name        = "your-repo-name"
  description = "Your repository description"
  visibility  = "private"
}

resource "github_repository_collaborator" "collaborator" {
  repository = github_repository.repo.name
  username   = "softservedata"
  permission  = "push"
}

resource "github_branch" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"
  source_branch = "main"
}

resource "github_branch_protection" "main" {
  repository = github_repository.repo.name
  branch     = "main"

  required_pull_request_reviews {
    dismiss_stale_reviews = true
    required_approving_review_count = 1
  }

  required_status_checks {
    strict = true
  }

  enforce_admins = true
  required_linear_history = true
  allow_force_pushes = false
  allow_deletions = false
}

resource "github_branch_protection" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"

  required_pull_request_reviews {
    dismiss_stale_reviews = true
    required_approving_review_count = 2
  }

  required_status_checks {
    strict = true
  }

  enforce_admins = true
  required_linear_history = true
  allow_force_pushes = false
  allow_deletions = false
}

resource "github_codeowner" "codeowner" {
  repository = github_repository.repo.name
  branch     = "main"
  owners     = ["softservedata"]
}

resource "github_repository_file" "pull_request_template" {
  repository = github_repository.repo.name
  file       = ".github/pull_request_template.md"
  content    = <<-EOT
Describe your changes
Issue ticket number and link
Checklist before requesting a review:
- [ ] I have performed a self-review of my code
- [ ] If it is a core feature, I have added thorough tests
- [ ] Do we need to implement analytics?
- [ ] Will this be part of a product update? If yes, please write one phrase about this update
EOT
  commit_message = "Add pull request template"
}

resource "github_deploy_key" "deploy_key" {
  repository = github_repository.repo.name
  title      = "DEPLOY_KEY"
  key        = var.deploy_key
  read_only  = false
}


variable "github_token" {}
variable "deploy_key" {}
