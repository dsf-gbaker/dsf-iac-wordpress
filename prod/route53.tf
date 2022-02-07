resource "aws_route53_record" "wordpress" {
  zone_id   = var.hosted-zone-id
  name      = "www.digitalsloth.com"
  type      = "A"

  alias {
    name    = data.terraform_remote_state.dsf.outputs.alb_dns
    zone_id = data.terraform_remote_state.dsf.outputs.alb_zoneid
    evaluate_target_health = true
  }
}