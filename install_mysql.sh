version: "3.8"

services:
  mysql:
    image: mysql:8.0
    container_name: mysql-server

    restart: unless-stopped

    environment:
      MYSQL_ROOT_PASSWORD: 1234
      MYSQL_DATABASE: mydb

    ports:
      - "3306:3306"

    volumes:
      - mysql-data:/var/lib/mysql

    command: --bind-address=0.0.0.0

volumes:
  mysql-data:
