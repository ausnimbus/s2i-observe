FROM ausnimbus/ausnimbus:v3.6.173.0.5

MAINTAINER AusNimbus <support@ausnimbus.com.au>

LABEL io.openshift.s2i.scripts-url=image:///usr/libexec/s2i

ENV \
    # Path to be used in other layers to place s2i scripts into
    STI_SCRIPTS_PATH=/usr/libexec/s2i \
    # The $HOME is not set by default, but some applications needs this variable
    HOME=/opt/app-root/src \
    PATH=/opt/app-root/src/bin:/opt/app-root/bin:$PATH \
    KUBECONFIG=/opt/app-root/src/.kube_config

COPY s2i/bin/ $STI_SCRIPTS_PATH
COPY bin/ /usr/bin/

RUN yum -y install openssl && \
    yum clean all && \
    mkdir -p ${HOME} && \
    useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin \
      -c "Default Application User" default && \
    chown -R 1001:0 /opt/app-root && \
    chmod -R ug+rwx /opt/app-root

WORKDIR ${HOME}
USER 1001

ENTRYPOINT ["container-entrypoint"]
CMD $STI_SCRIPTS_PATH/usage
