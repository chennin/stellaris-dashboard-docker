ARG PY_VER="3.10"
ARG OS_VER="bullseye"
FROM python:${PY_VER}-slim-${OS_VER}
ARG SD_TAG="master"
ARG GIT_SD_USER="eliasdoehne"
ARG GIT_SD_NAME="stellaris-dashboard"

USER root

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y dist-upgrade && \
    apt-get -y --no-install-recommends install \
      gcc libc6-dev curl \
      dumb-init \
      git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN useradd --create-home --shell /bin/bash stellaris

USER stellaris
WORKDIR /home/stellaris
ENV PATH "/home/stellaris/.local/bin:$PATH"

RUN mkdir -p "/home/stellaris/.local/share/Paradox Interactive/Stellaris/save games" "/home/stellaris/.steam/steamapps/common/Stellaris/localisation/english"
ADD --chown=stellaris https://api.github.com/repos/$GIT_SD_USER/$GIT_SD_NAME/git/refs/heads/$SD_TAG sd_version.json
RUN git clone -b "$SD_TAG" -c advice.detachedHead=false https://github.com/$GIT_SD_USER/$GIT_SD_NAME.git
RUN pip install --no-cache-dir --upgrade pip && pip --no-cache-dir install wheel setuptools && \
    pip --no-cache-dir install Cython patchelf && \
    pip --no-cache-dir install -r stellaris-dashboard/requirements.txt -r stellaris-dashboard/dev-requirements.txt

WORKDIR /home/stellaris/stellaris-dashboard

COPY run.sh /run.sh
COPY build-ext.sh /build-ext.sh
RUN /build-ext.sh

EXPOSE 28053

ENTRYPOINT ["dumb-init"]

#CMD ["python", "-m", "stellarisdashboard"]
CMD ["/run.sh"]
