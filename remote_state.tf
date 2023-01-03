/*
data "terraform_remote_state" "your forked repo" {
    backend = "remote"
    config = {
        organization = "your TF cloud org"
        workspaces = {
            name = "your TF cloud worksapce"
        }
    }
}

output "remote_state" {
    value = data.terraform_remote_state.<your forked repo>
}
*/