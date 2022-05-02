FROM alpine:latest
RUN apk update && apk add openssh && apk add openrc
RUN mkdir -p /home/root/.ssh && ln -s /run/secrets/user_ssh_key /home/root/.ssh/id_rsa.pub
RUN chown -R root:root /home/root/.ssh
EXPOSE 22
CMD ["sh"]
