# Skipped

This task is skipped because of errors in accessing Covid-19 API.

The API endpoint [https://api.covid19api.com/summary/](https://api.covid19api.com/summary/) throws "404 Not Found" error.

## Error
```
curl --location 'https://api.covid19api.com' \ 
--header 'Authorization: Basic XXXYYYZZZ' \
-k -v

*   Trying 18.132.189.102...
* TCP_NODELAY set
* Connected to api.covid19api.com (18.132.189.102) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/cert.pem
  CApath: none
* TLSv1.2 (OUT), TLS handshake, Client hello (1):
* TLSv1.2 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES128-GCM-SHA256
* ALPN, server accepted to use h2
* Server certificate:
*  subject: CN=api.covid19api.com
*  start date: Apr 30 12:11:30 2023 GMT
*  expire date: Jul 29 12:11:29 2023 GMT
*  issuer: C=US; O=Let's Encrypt; CN=R3
*  SSL certificate verify ok.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x7fa5a580d200)
> GET / HTTP/2
> Host: api.covid19api.com
> User-Agent: curl/7.64.1
> Accept: */*
> Authorization: Basic Y29yb25hOlpVYXY0dmF3ekNmTWNNWEhWOEI=
> 
* Connection state changed (MAX_CONCURRENT_STREAMS == 128)!
< HTTP/2 404 
< date: Mon, 22 May 2023 07:45:36 GMT
< content-type: text/html
< content-length: 146
< strict-transport-security: max-age=15724800; includeSubDomains
< 
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx</center>
</body>
</html>
* Connection #0 to host api.covid19api.com left intact
* Closing connection 0
```
