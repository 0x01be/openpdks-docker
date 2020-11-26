ARG PDK_VARIANT=all
ARG REVISION=master

FROM 0x01be/skywater-pdk:$PDK_VARIANT as build

RUN apk add --no-cache --virtual openpdks-build-dependencies \
    bash \
    python3 \
    tcl \
    tk

RUN git clone --depth 1 --branch ${REVISION} https://github.com/RTimothyEdwards/open_pdks.git /opt/openpdks

WORKDIR /opt/openpdks

ENV PDK_ROOT=/opt/skywater-pdk
RUN ./configure --with-sky130-source=/opt/skywater --with-sky130-local-path=/opt/skywater
RUN make
RUN make install

