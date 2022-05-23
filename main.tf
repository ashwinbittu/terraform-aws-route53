/*resource "aws_route53_zone" "route53" {
  name = var.aws_route53_zone_name
 
  #vpc {
  #  vpc_id = var.aws_vpc_id
  #}
  
 tags = {
    Name = var.aws_route53_zone_name
    environment  = var.app_env
    appname = var.app_name
    appid = var.app_id
  }

}*/

resource "aws_route53_record" "www-record" {
  #zone_id = aws_route53_zone.route53.zone_id
  zone_id = var.aws_route53_zone_id
  name    =  var.aws_route53_record_name 
  type    = "A"
  set_identifier  = "service-${var.aws_region}"
  
  #This flag is very important to make sure that we can update the ELB name after every repave. PLEASE DONT REMOVE IT
  allow_overwrite  = true

  alias {
    name = var.aws_elb_dns_name 
    zone_id = var.aws_elb_zone_id
    evaluate_target_health = true
  }

  latency_routing_policy {
    region = var.aws_region
  }

}


/*This is for modifying default NS records with your actual Domain NS
resource "aws_route53_record" "route53-NSR" {
  allow_overwrite = true
  name            = var.aws_route53_zone_name
  ttl             = 30
  type            = "NS"
  zone_id         = aws_route53_zone.route53.zone_id
  records 	  = ["ns-1536.awsdns-00.co.uk", "ns-0.awsdns-00.com", "ns-1024.awsdns-00.org", "ns-512.awsdns-00.net"]
  #records 	  = var.aws_dns_records
}*/


