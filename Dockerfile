ARG PDK_VARIANT=minimal

FROM 0x01be/magic:xpra as magic

FROM 0x01be/skywater-pdk:$PDK_VARIANT as build

RUN apk add --no-cache --virtual openpdks-build-dependencies \
    coreutils \
    bash \
    python3 \
    tcl \
    tk \
    cairo \
    glu

COPY --from=magic /opt/magic/ /opt/magic/

WORKDIR /opt/openpdks
ENV PDK_ROOT=/opt/skywater-pdk \
    REVISION=1.0.88
RUN git clone --depth 1 --branch ${REVISION} https://github.com/RTimothyEdwards/open_pdks.git /opt/openpdks &&\
    ln -s /opt/magic/bin/magic /usr/bin/magic &&\
    sed -i.bak "s/ version REVISION/ version 1.0.88/" /opt/openpdks/sky130/magic/sky130.tech &&\
    ./configure \
    --with-sky130-source=/opt/skywater-pdk \
    --with-sky130-local-path=/opt/skywater-pdk \
    --with-sky130-dist-path=/opt/skywater-pdk  &&\
    make &&\
    make install

