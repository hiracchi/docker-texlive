FROM hiracchi/ubuntu-ja:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/hiracchi/docker-texlive" \
  org.label-schema.version=$VERSION \
  maintainer="Toshiyuki Hirano <hiracchi@gmail.com>"


ARG WORKDIR="/work"
ENV LC_ALL=C LANG=C DEBIAN_FRONTEND=noninteractive

ENV PACKAGES="\
  make \
  texlive-science \
  texlive-lang-japanese texlive-lang-cjk texlive-fonts-recommended texlive-fonts-extra \
  xdvik-ja \
  dvipng \
  gv nkf gnuplot tgif gimp inkscape mimetex latexdiff latexmk \
  "
# dvipsk-ja was removed on the ubuntu repository.


# setup packages ===============================================================
RUN set -x && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  ${PACKAGES} \
  && \
  apt-get clean && \
  apt-get autoclean && \
  rm -rf /var/lib/apt/lists/* 

# -----------------------------------------------------------------------------
# entrypoint
# -----------------------------------------------------------------------------
COPY scripts/* /usr/local/bin/

RUN set -x && \
  mkdir -p "${WORKDIR}"
WORKDIR "${WORKDIR}"

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/local/bin/usage.sh"]
