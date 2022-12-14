FROM quay.io/centos/centos:stream8

RUN dnf module -y install python39 && dnf install -y python39 python39-pip git make gcc lksctp-tools-devel
RUN git clone -b 1.0.7 https://github.com/uperf/uperf.git /uperf
RUN cd /uperf && ./configure && make && make install

RUN mkdir /plugin /plugin/profiles
ADD uperf_plugin.py /plugin
ADD profiles /plugin/profiles
ADD test_uperf_plugin.py /plugin
ADD requirements.txt /plugin
#ADD server_input.yaml /plugin
#ADD input.yaml /plugin
WORKDIR /plugin

RUN pip3 install -r requirements.txt
#RUN /usr/local/bin/python3 test_uperf_plugin.py

USER 1000

EXPOSE 20000

ENTRYPOINT ["python3.9", "uperf_plugin.py"]
CMD []

LABEL org.opencontainers.image.source="https://github.com/jaredoconnell/arcalot-uperf/blob/main/uperf_plugin.py"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.vendor="Arcalot project"
LABEL org.opencontainers.image.authors="Arcalot contributors"
LABEL org.opencontainers.image.title="Uperf Arcalot Plugin"
LABEL io.github.arcalot.arcaflow.plugin.version="1"