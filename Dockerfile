FROM mysql:5.7.12

COPY entrypoint.sh /tmp

ENTRYPOINT ["/tmp/entrypoint.sh"]
