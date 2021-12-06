resource "ibm_is_lb" "lb" {
  name    = "lb-to-cos"
  subnets = ["02i7-2af135b3-173d-4eb8-bb4b-f49fea5ecd65"]
  type = "private"
}


resource "ibm_is_lb_pool" "pool" {
  name           = "lb-pool"
  lb             = ibm_is_lb.lb.id
  algorithm      = "round_robin"
  protocol       = "tcp"
  health_delay   = 60
  health_retries = 5
  health_timeout = 30
  health_type    = "tcp"
}


resource "ibm_is_lb_listener" "lb_listener" {
  lb       = ibm_is_lb.lb.id
  port     = "443"
  protocol = "tcp"
  default_pool = ibm_is_lb_pool.pool.id
} 


resource "ibm_is_lb_pool_member" "lb_member" {
  lb             = ibm_is_lb.lb.id
  pool           = ibm_is_lb_pool.pool.pool_id
  port           = 443
  target_address = "10.245.64.7"
  weight         = 60
}