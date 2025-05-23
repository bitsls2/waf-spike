Albedo is a simple HTTP server used as a reverse-proxy backend in testing web application firewalls (WAFs). go-ftw relies on Albedo to test WAF rules of responses.  https://github.com/coreruleset/albedo

packages are created on github here 

Goal
Create albedo as a kubernetes service which can be accesed via an niginx ingress controller

It should be possible to test the ingress controller using go-ftw
