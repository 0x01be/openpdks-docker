ARG PDK_VARIANT=all

FROM 0x01be/skywater-pdk:$PDK_VARIANT as skywater-pdk

FROM alpine as build

COPY --from=skywater-pdk /opt/skywater-pdk/ /opt/skywater-pdk/

ENV PDK_ROOT /opt/skywater-pdk

RUN apk add --no-cache --virtual openpdks-build-dependencies \
    git \
    make \
    bash \
    python3 \
    tcl \
    tk

RUN git clone --depth 1 https://github.com/efabless/open_pdks /openpdks

WORKDIR /openpdks

RUN make
RUN make install

FROM alpine

COPY --from=build /opt/skywater-pdk/ /opt/skywater-pdk/

