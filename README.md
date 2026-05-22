# clickNbuy-SpringBoot-Thymeleaf
clickNbuy-SpringBoot-Thymeleaf

docker exec -it app_mysql bash

mysql -u root -p



# Spring Boot + MySQL Application + Nginx (Reverse-Proxy)
---
<img width="1132" height="774" alt="image" src="https://github.com/user-attachments/assets/461d49db-abe8-476c-9dad-544b8a285d41" />

---
## Configuration Details
### `application.properties`
```properties
spring.datasource.url=jdbc:mysql://mysql-container:3306/myapplication?createDatabaseIfNotExist=true
spring.datasource.username=root
spring.datasource.password=1234
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```
---
## admin login
- username: admin
- password: admin
---
## nginx configuration
---
### Create Nginx config: On the Nginx server:
```bash
sudo vi /etc/nginx/sites-available/reverse-proxy
```
- Paste this:
```bash
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    location / {
        proxy_pass http://13.235.57.138:8081;
        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
### Enable config
```bash
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```
---

