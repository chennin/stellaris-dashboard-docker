ARG PY_VER="3.10"
ARG ALPINE_VER="3.17"
FROM python:${PY_VER}-alpine${ALPINE_VER}
ARG SD_TAG="master"

USER root

RUN apk update && apk upgrade && \
    apk --no-cache add \
      dumb-init \
      git \
      gcc libc-dev \
      py3-numpy py3-scipy py3-matplotlib py3-contourpy py3-kiwisolver py3-greenlet && \
    rm -rf /var/cache/apk/*
RUN adduser --disabled-password stellaris

USER stellaris
WORKDIR /home/stellaris
ENV PATH "/home/stellaris/.local/bin:$PATH"
ENV PYTHONPATH "${PYTHONPATH}:/usr/lib/python3.10/site-packages"

RUN mkdir -p "/home/stellaris/.local/share/Paradox Interactive/Stellaris/save games" "/home/stellaris/.steam/steamapps/common/Stellaris/localisation/english"
RUN git clone https://github.com/eliasdoehne/stellaris-dashboard.git && \
    git -C stellaris-dashboard -c advice.detachedHead=false checkout "$SD_TAG"
RUN pip install --upgrade pip && pip install wheel setuptools && \
    pip install Cython && \
    pip install $(cat stellaris-dashboard/requirements.txt | grep -Ev "^(matplotlib|scipy|numpy|contourpy|kiwisolver|greenlet)") && \
    pip cache purge

WORKDIR /home/stellaris/stellaris-dashboard
RUN python setup.py build_ext --inplace

USER root
RUN apk del gcc libc-dev
USER stellaris

COPY run.sh /run.sh

EXPOSE 28053

ENTRYPOINT ["dumb-init"]

CMD ["/run.sh"]
