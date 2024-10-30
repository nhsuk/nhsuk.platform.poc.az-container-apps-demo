# resource "azurerm_frontdoor" "front_door" {
#   name                = "fd-${var.app_name}"
#   resource_group_name = var.resource_group_name

#   backend_pool {
#     name                = "${var.app_name}-backend-pool"
#     load_balancing_name = "${var.app_name}-load-balancing"
#     health_probe_name   = "${var.app_name}-health-probe"

#     backend {
#       address     = azurerm_container_app.container_app.ingress[0].fqdn
#       host_header = azurerm_container_app.container_app.ingress[0].fqdn
#       http_port   = 80
#       https_port  = 443
#       enabled     = true
#       priority    = 1
#       weight      = 100
#     }
#   }

#   backend_pool_health_probe {
#     name                = "${var.app_name}-health-probe"
#     protocol            = "Https"
#     path                = "/"
#     interval_in_seconds = 30
#   }

#   backend_pool_load_balancing {
#     name                            = "${var.app_name}-load-balancing"
#     additional_latency_milliseconds = 0
#     sample_size                     = 4
#     successful_samples_required     = 2
#   }


#   frontend_endpoint {
#     name      = "${var.app_name}-frontend"
#     host_name = "${var.app_name}.azurefd.net"
#   }

#   routing_rule {
#     name               = "${var.app_name}-routing-container-app"
#     accepted_protocols = ["Https"]
#     patterns_to_match  = ["/*"]
#     frontend_endpoints = ["${var.app_name}-frontend"]
#     forwarding_configuration {
#       forwarding_protocol = "MatchRequest"
#       backend_pool_name   = "${var.app_name}-backend-pool"
#     }
#   }
# }
