    terraform {
      backend "remote" {
        organization = "o5command"
        workspaces {
          name = "o5command"
        }
      }
    }