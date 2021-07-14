domain = "darvein.xyz"
stage  = "base"
vpc_cidr = "10.50.0.0/16"
vpc_availability_zones = [
    "us-west-2a",
    "us-west-2b",
    "us-west-2c",
]
vpc_private_subnets = [
    "10.50.0.0/21",
    "10.50.8.0/21",
    "10.50.16.0/21",
]
vpc_public_subnets = [
    "10.50.64.0/21",
    "10.50.72.0/21",
    "10.50.80.0/21",
]
