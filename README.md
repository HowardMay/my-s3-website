#Goals
Create a multi-environment project 
Driven by shared modules
Stored in git
Deployed to AWS

#Tasks
1) Refactor to create multiple domains 
2) Move main.tf to "dev" 
3) Create "test" and "prod" env
4) Create Access control lists for "dev" and "test" - DON'T do this - AWS charges $5 a month per WAF
5) Add to git

#Supporting multiple environments using CloudFront
Terraform does not support dynamic addition of origins to CloudFront. Therefore it is necessary to use 
different domains for different environments.
