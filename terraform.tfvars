project_id   = "<your_project>"
api_services = "run.googleapis.com"
location     = "europe-west4"

service_name       = "ots"
container_name     = "gcr.io/<your_project>/ots:latest"
container_port     = "3000"
domain_mapped_name = "ots.<your_domain>"
