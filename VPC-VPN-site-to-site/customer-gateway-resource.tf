################################################################
# Customer Gateway Resource
################################################################

resource "aws_customer_gateway" "vyos_lab" {
  bgp_asn    = 65000
  ip_address = "35.175.139.241"  # UPDATE: Replace with your public IP
  type       = "ipsec.1"

  tags = merge(local.tags, {
    Name        = "${local.name}-customer-gateway"
    Description = "Customer Gateway for on-premises connection"
  })
}
