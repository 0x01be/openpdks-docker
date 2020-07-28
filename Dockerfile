ARG PDK_VARIANT=sky130_fd_sc_hd

FROM 0x01be/skywalker-pdk:$PDK_VARIANT as skywalker-pdk

FROM alpine:3.12.0 as builder

COPY --from=skywalker-pdk /opt/skywalker-pdk/ /opt/skywalker-pdk/

ENV PDK_ROOT /opt/skywalker-pdk
ENV PDK_VARIANT $PDK_VARIANT

RUN apk add --no-cache --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
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

