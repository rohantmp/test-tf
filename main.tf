resource "kubernetes_pod" "test" {
  metadata {
    name = var.name
    namespace = "loft-p-default"
  }

  spec {
    container {
      image = var.image
      name  = "example"

      env {
	name  = "environment"
	value = "test"
      }

      port {
	container_port = 80
      }

      liveness_probe {
	http_get {
	  path = "/"
	  port = 80

	  http_header {
	    name  = "X-Custom-Header"
	    value = "Awesome"
	  }
	}

	initial_delay_seconds = 3
	period_seconds        = 3
      }
    }

    dns_config {
      nameservers = ["1.1.1.1", "8.8.8.8", "9.9.9.9"]
      searches    = ["example.com"]

      option {
	name  = "ndots"
	value = 1
      }

      option {
	name = "use-vc"
      }
    }

    dns_policy = "None"
  }
}

variable "name" {
  type = string
  default = "terraform-example"
}

variable "image" {
  type = string
  default = "nginx:1.21.6"
}
