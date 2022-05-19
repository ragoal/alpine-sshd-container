# Creación de contenedor
Dockerfile
```
FROM alpine:latest
ARG ssh_pub_key

RUN mkdir -p /root/.ssh \
    && chmod 0700 /root/.ssh \
    && passwd -u root \
    && echo "$ssh_pub_key" > /root/.ssh/authorized_keys \
    && apk add openrc openssh python3\
    && ssh-keygen -A \
    && echo -e "PasswordAuthentication no" >> /etc/ssh/sshd_config \
    && mkdir -p /run/openrc \
    && touch /run/openrc/softlevel
RUN rc-status

ENTRYPOINT ["sh", "-c", "rc-service sshd restart && tail -f /dev/null"]

```
crear imagen pasando como argumento nuestra clave pública ssh
```
docker build --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" -t alpine1 .
```
Ejecutar el contendor con la imagen creada y elegir el puerto donde publicará el servicio ssh
```
docker run -d --name alpine-ssh -p 7655:22 alpine1
```
sentencia ansible para validar ping, la primera vez nos pedirá validar host ssh
```
ansible alpine1 -m ping -i ansible
```
configurar el fichero de inventario asbile
```
alpine1 ansible_port=7655 ansible_host=192.168.1.35 ansible_user=root
```

# Creación con docker-compose

```
docker-compose.yml
version: "3.3"
services:
  web:
    build:
      context: .
      args:
        ssh_pub_key: "${RSA}"
    image: alpine_ssh_2
    ports:
      - "${SSH_PORT}:22"
```

volcar en variable de entorno RSA la id_rsa.pub
```
export RSA=$(cat ~/.ssh/id_rsa.pub)
```
variable puerto a exponer el ssh del contendor
```
export SSH-PORT=7655
```
Levantar contenedor
```
docker-compose up -d --build 
```

