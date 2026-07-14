FROM ghcr.io/captonsssssss-sys/comfy-change-clothes:latest

USER root

RUN pip3 install --no-cache-dir jupyterlab

COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh

EXPOSE 8188 8888

CMD ["/root/start.sh"]
