ARG PDK_VARIANT=all

FROM 0x01be/skywater-pdk:$PDK_VARIANT as build

RUN apk add --no-cache --virtual openpdks-build-dependencies \
    git \
    make \
    bash \
    python3 \
    tcl \
    tk

RUN git clone --depth 1 https://github.com/efabless/open_pdks /opt/openpdks

WORKDIR /opt/openpdks

ENV PDK_ROOT=/opt/skywater-pdk
RUN make
RUN make install

FROM alpine

COPY --from=build /opt/openpdks/ /opt/openpdks/

