FROM nginx:latest

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod 755 /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
