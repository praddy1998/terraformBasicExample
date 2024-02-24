
variable "domain" { 
   //default =  "testtrial.com"
}

variable "sub-domain" {
  //default = "test-api1.testtrial.com"
}

variable "subject_alternative_names" {
  type = list(string)
  default = [ ]
  
}