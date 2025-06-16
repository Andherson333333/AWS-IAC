################################################################
# Outputs
################################################################

output "infrastructure_info" {
  description = "Basic infrastructure information"
  value = {
    vpc_id            = module.vpc_lab.vpc_id
    vpc_cidr          = module.vpc_lab.vpc_cidr_block
    private_subnets   = module.vpc_lab.private_subnets
    public_subnets    = module.vpc_lab.public_subnets
    ec2_instance_id   = module.ec2_test_server.id
    ec2_private_ip    = module.ec2_test_server.private_ip
  }
}

output "vpn_connection_info" {
  description = "VPN connection information for Customer Gateway configuration"
  value = {
    vpn_connection_id   = module.vpn_gateway.vpn_connection_id
    customer_gateway_id = aws_customer_gateway.vyos_lab.id
    vpn_gateway_id      = module.vpc_lab.vgw_id

    tunnel1_address = module.vpn_gateway.vpn_connection_tunnel1_address
    tunnel2_address = module.vpn_gateway.vpn_connection_tunnel2_address

    tunnel1_customer_inside_ip = module.vpn_gateway.vpn_connection_tunnel1_cgw_inside_address
    tunnel1_aws_inside_ip      = module.vpn_gateway.vpn_connection_tunnel1_vgw_inside_address
    tunnel2_customer_inside_ip = module.vpn_gateway.vpn_connection_tunnel2_cgw_inside_address
    tunnel2_aws_inside_ip      = module.vpn_gateway.vpn_connection_tunnel2_vgw_inside_address

    aws_bgp_asn      = "64512"
    customer_bgp_asn = "65000"
  }
}

output "vpn_connection_id" {
  description = "VPN Connection ID for manual PSK retrieval"
  value = module.vpn_gateway.vpn_connection_id
}

output "useful_commands" {
  description = "Useful AWS CLI commands for VPN information"
  value = {
    get_vpn_details = "aws ec2 describe-vpn-connections --vpn-connection-ids ${module.vpn_gateway.vpn_connection_id}"
    get_psk_tunnel1 = "aws ec2 describe-vpn-connections --vpn-connection-ids ${module.vpn_gateway.vpn_connection_id} --query 'VpnConnections[0].Options.TunnelOptions[0].PreSharedKey' --output text"
    get_psk_tunnel2 = "aws ec2 describe-vpn-connections --vpn-connection-ids ${module.vpn_gateway.vpn_connection_id} --query 'VpnConnections[0].Options.TunnelOptions[1].PreSharedKey' --output text"
    get_vpn_info    = "terraform output vpn_connection_info"
  }
}
