variable "domain_name" {
  default     = "andrewchu.us"
  description = "domain name"
  type        = string
}

variable "record_name" {
  default     = "fleetcart"
  description = "record name"
  type        = string
}

variable "ami_image" {
  default     = "ami-070136c711760a91a"
  description = "ami of production fleetcart web server"
  type        = string
}