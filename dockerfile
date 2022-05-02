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
