#
# File : main.tf
# Created : May 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
## Global external HTTP(S) load balancer (classic)

# IP address used for HTTP(S) load balancing
resource "google_compute_global_address" "frontend" {
  name         = "ip-lb-${var.component_name_abbreviation}-${var.environment}-${var.instance_suffix}"
  project      = var.project
  address_type = "EXTERNAL"
}

# used to forward traffic to the correct load balancer for HTTP load balancing
resource "google_compute_global_forwarding_rule" "http" {
  name    = "fr-http-${var.component_name_abbreviation}-${var.environment}-${var.instance_suffix}"
  project = var.project

  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.frontend.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"

  labels = {
    environment = var.environment
  }
}

# used to forward traffic to the correct load balancer for HTTPS load balancing
resource "google_compute_global_forwarding_rule" "https" {
  name    = "fr-https-${var.component_name_abbreviation}-${var.environment}-${var.instance_suffix}"
  project = var.project

  target                = google_compute_target_https_proxy.default.id
  ip_address            = google_compute_global_address.frontend.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"

  labels = {
    environment = var.environment
  }
}

# routes incoming HTTP requests to a URL map
# argument `http_keep_alive_timeout_sec` is not available for classic load balancers
resource "google_compute_target_http_proxy" "default" {
  name    = "proxy-http-${var.component_name_abbreviation}-${var.environment}-${var.instance_suffix}"
  project = var.project
  url_map = google_compute_url_map.https_redirect.id
}

# routes incoming HTTPS requests to a URL map
# argument `http_keep_alive_timeout_sec` is not available for classic load balancers
resource "google_compute_target_https_proxy" "default" {
  name             = "proxy-https-${var.component_name_abbreviation}-${var.environment}-${var.instance_suffix}"
  project          = var.project
  url_map          = google_compute_url_map.default.id
  ssl_certificates = var.ssl_certificate_self_links
}

# used to redirect HTTP to HTTPS
resource "google_compute_url_map" "https_redirect" {
  name    = "url-map-http-${var.component_name_abbreviation}-${var.environment}-${var.instance_suffix}"
  project = var.project

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

# used to route HTTPS requests to the backend service
resource "google_compute_url_map" "default" {
  name            = "url-map-https-${var.component_name_abbreviation}-${var.environment}-${var.instance_suffix}"
  project         = var.project
  default_service = google_compute_backend_service.default.id
}

# backend service of the load balancer
resource "google_compute_backend_service" "default" {
  name    = "bs-${var.component_name_abbreviation}-${var.environment}-${var.instance_suffix}"
  project = var.project
  backend {
    group           = google_compute_instance_group.default.id
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
  health_checks         = [google_compute_health_check.default.id]
  load_balancing_scheme = "EXTERNAL"
  port_name             = "http"
  protocol              = "HTTP"
  timeout_sec           = var.timeout_sec
}

# unmanaged instance group with single instance
resource "google_compute_instance_group" "default" {
  name      = "umig-${var.component_name_abbreviation}-${var.environment}-${var.instance_suffix}"
  project   = var.project
  zone      = var.instance_zone
  instances = [var.instance_self_link]
  named_port {
    name = "http"
    port = 80
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_health_check" "default" {
  name    = "hc-${var.component_name_abbreviation}-${var.environment}-${var.instance_suffix}"
  project = var.project

  check_interval_sec  = 30
  healthy_threshold   = 5
  timeout_sec         = 5
  unhealthy_threshold = 2
  http_health_check {
    request_path = "/" # Just request the index.html
    port         = 80
  }
}
