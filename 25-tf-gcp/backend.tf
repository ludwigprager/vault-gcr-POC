terraform {
  backend "gcs" {
    # unique name to identify the file within the bucket
    prefix  = "tf-vault-gcr-poc"
  }

# required_providers {
#   google = {
#     source  = "mycorp/mycloud"
#     version = "~> 1.1.19"
#   }
# }

}
