FROM intelsdi/snap:xenial

RUN apt-get update && apt-get -y install netcat-traditional sysstat curl

ENV PLUGIN_URL=https://s3-us-west-2.amazonaws.com/snap.ci.snap-telemetry.io/plugins

RUN for p in collector-cpu collector-interface collector-iostat collector-load collector-meminfo publisher-graphite; do \
  curl --create-dirs $PLUGIN_URL/snap-plugin-$p/latest/linux/x86_64/snap-plugin-$p -o /opt/snap/plugins/snap-plugin-$p; done

COPY plugins/snap-plugin-collector-docker plugins/snap-plugin-collector-kubestate /opt/snap/plugins/

COPY snapteld.conf /etc/snap/snapteld.conf

COPY start.sh /usr/local/bin
RUN mkdir /opt/snap/tasks && chmod a+x /opt/snap/tasks && chmod a+x /opt/snap/bin/* && chmod a+x /opt/snap/sbin/* && chmod a+x /opt/snap/plugins/*
CMD /usr/local/bin/start.sh
