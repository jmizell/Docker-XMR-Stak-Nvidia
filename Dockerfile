FROM nvidia/cuda:9.0-devel-centos7

RUN yum install centos-release-scl epel-release -y \
    && yum install cmake3 devtoolset-4-gcc* hwloc-devel libmicrohttpd-devel openssl-devel make git -y

ENV XMRSTAK_RELEASE 2.10.7

RUN git clone https://github.com/fireice-uk/xmr-stak.git /root/xmr-stak \
    && cd /root/xmr-stak \
    && git tag -l \
    && git checkout tags/${XMRSTAK_RELEASE}

RUN source scl_source enable devtoolset-4 \
    && mkdir -p /root/xmr-stak/build \
    && cd /root/xmr-stak/build \
    && cmake3 .. -DOpenCL_ENABLE=OFF \
    && make install \
    && cp -rva /root/xmr-stak/build/bin/* /usr/local/bin/

RUN adduser --shell /bin/sh xmrstak \
    && mkdir -p /xmrstak \
    && chown -Rv xmrstak:xmrstak /xmrstak

WORKDIR /xmrstak

USER xmrstak

CMD /usr/local/bin/xmr-stak