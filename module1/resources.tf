provider "aws" {
    profile = "deep-dive"
    region = var.region
}

data "aws_availability_zones" "available" {}

##network
module "vpc" {
    source = "terraform-aws-modules/vpc/aws"    


    name = "globo_primary"

    cidr = var.cidr_block
    azs = slice(data.aws_availability_zones.available.names,0,var.subnet_count) # zonas de disponibilidade  ; 0 comecando com o primerio elemento da lista. var.subnet_cont  = valor do ultimo da list (q no caso é 2 q definimos)
    public_subnets = var.public_subnets
    private_subnets = var.private_subnets

    enable_nat_gateway = false

    create_database_subnet_group = false


    tags = {
        Environments = "Production"
        Team = "Network"
    }
}