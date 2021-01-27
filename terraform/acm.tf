data "aws_acm_certificate" "main" {
  domain   = "${var.sub_domain}.${var.domain}"
  statuses = ["ISSUED"]
}
