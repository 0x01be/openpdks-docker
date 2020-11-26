ARG PDK_VARIANT=all

FROM 0x01be/skywater-pdk:$PDK_VARIANT as build

ENV REVISION=master
RUN apk add --no-cache --virtual openpdks-build-dependencies \
    coreutils \
    bash \
    python3 \
    tcl \
    tk \
    cairo \
    glu &&\
    git clone --depth 1 --branch ${REVISION} https://github.com/RTimothyEdwards/open_pdks.git /opt/openpdks

COPY --from=0x01be/magic:build /opt/magic/ /opt/magic/

WORKDIR /opt/openpdks

ENV PDK_ROOT=/opt/skywater-pdk

RUN ln -s /opt/magic/bin/magic /usr/bin/magic &&\
    sed -i.bak "s/ version REVISION/ version $(date '+%Y%m%d%H%M%S')/" /opt/openpdks/sky130/magic/sky130.tech &&\
    ./configure \
    --with-sky130-source=/opt/skywater-pdk \
    --with-sky130-local-path=/opt/skywater-pdk \
    --with-sky130-dist-path=/opt/skywater-pdk  &&\
    make &&\
    make install

