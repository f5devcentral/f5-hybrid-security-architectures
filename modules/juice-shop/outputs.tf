output "juice_shop_ip" {
    value = aws_instance.app-server.private_ip
}
output "nat_gateway_id" {
    value = aws_nat_gateway.main.id
}
    