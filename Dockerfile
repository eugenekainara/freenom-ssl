FROM python:3-alpine

RUN apk add gcc libffi-dev linux-headers musl-dev openssl-dev git jq --update && \
    pip install certbot && \
    git clone https://github.com/whatever4711/Freenom-dns-updater.git /freenom-dns-updated && \
    cd /freenom-dns-updated/ && \
    pip install -r requirements.txt && \
    python setup.py install && \
    apk del linux-headers musl-dev gcc

ADD *.sh /

VOLUME /etc/letsencrypt/

ENTRYPOINT ["/certificate-obtainer.sh"]
