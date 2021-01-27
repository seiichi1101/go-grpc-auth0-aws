data "aws_route53_zone" "main" {
  name         = var.domain
  private_zone = false
}

resource "aws_route53_record" "main" {
  type = "A"

  name    = "${var.sub_domain}.${var.domain}"
  zone_id = data.aws_route53_zone.main.id

  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = true
  }
}
