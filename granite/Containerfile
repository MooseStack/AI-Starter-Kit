FROM docker.io/redhat/granite-3-2b-instruct:1.0

USER root

WORKDIR /opt

RUN pip3 --version

COPY --chmod=755 entrypoint.sh llama.sh /opt/

ENTRYPOINT ["/bin/bash", "-c", "/opt/entrypoint.sh"]