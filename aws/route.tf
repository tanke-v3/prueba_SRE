resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "prueba_sre.prueba.com"
  type    = "A"
  ttl     = 300
  records = [aws_eip.lb.public_ip]
}
