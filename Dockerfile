# https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management

FROM alpine:3.10

# Your system user
ARG USER='luiz'
# SMB and SYSTEM password
ARG PASS='smbpass'
ARG VERSION='4.11'

RUN apk add --no-cache --update sudo \
	'samba-common-tools<'${VERSION}'' \
    'samba-client<'${VERSION}'' \
    'samba-server<'${VERSION}''

RUN apk add --no-cache --update    # If your base image does not contain sudo.
RUN adduser -D -s /bin/ash -u 1000 ${USER} && addgroup ${USER} root  # Grant sudo to the user
RUN echo ''${USER}' ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN echo -ne ""${PASS}"\n"${PASS}"\n" | sudo smbpasswd -a -s ${USER}
RUN echo -ne ""${PASS}"\n"${PASS}"\n" | sudo passwd ${USER}
USER ${USER}

COPY smb.conf /etc/samba/smb.conf

EXPOSE 445/tcp
EXPOSE 445/udp

EXPOSE 139/tcp
EXPOSE 139/udp

EXPOSE 137/tcp
EXPOSE 137/udp

EXPOSE 138/tcp
EXPOSE 138/udp

CMD ["sudo", "smbd", "--foreground", "--log-stdout", "--no-process-group"]