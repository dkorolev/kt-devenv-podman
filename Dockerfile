# Please refer to `devenv.sh` for run instructions.

FROM alpine:latest

RUN apk update

RUN apk add bash
RUN apk add gradle

RUN apk add git vim

RUN mkdir -p /usr/local/bin
RUN echo -e '#!/bin/bash\ngradle clean' >/usr/local/bin/c
RUN echo -e '#!/bin/bash\ngradle build -x test' >/usr/local/bin/b
RUN echo -e '#!/bin/bash\ngradle run -q' >/usr/local/bin/r
RUN echo -e '#!/bin/bash\ngradle test -q -Dtestlogger.logLevel=quiet --rerun' >/usr/local/bin/t
RUN chmod +x /usr/local/bin/c
RUN chmod +x /usr/local/bin/b
RUN chmod +x /usr/local/bin/r
RUN chmod +x /usr/local/bin/t

ENV PS1='\[\033[01;35m\]{gradle-podman-devenv}\033[00m\] \w \$ '

WORKDIR /work

ENTRYPOINT ["/bin/bash"]
