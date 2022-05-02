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
    && touch /run/openrc/softlevel \
    && rc-status

CMD ["rc-service", "sshd", "start"]
CMD ["tail", "-f", "/dev/null"]
ENTRYPOINT ["sh", "-c", "rc-status; rc-service sshd start; sh"]
```
crear imagen pasando como argumento nuestra clave pública ssh
```
docker build --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" -t alpine1 .
```
Ejecutar el contendor con la imagen creada y elegir el puerto donde publicará el servicio ssh
```
docker run -dit --name alpine-ssh -p 7655:22 alpine1
```
sentencia ansible para validar ping, la primera vez nos pedirá validar host ssh
```
ansible alpine1 -m ping -i ansible
```
configurar el fichero de inventario asbile
```
alpine1 ansible_port=7655 ansible_host=192.168.1.35 ansible_user=root
```
