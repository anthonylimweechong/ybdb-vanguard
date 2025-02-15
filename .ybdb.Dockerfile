FROM gitpod/workspace-full

ARG YB_VERSION=2.19.2.0
ARG YB_BUILD=121
ARG YB_BIN_PATH=/usr/local/yugabyte
ARG ROLE=gitpod

USER $ROLE
# create bin and data path
RUN sudo mkdir -p $YB_BIN_PATH

# set permission
RUN sudo chown -R $ROLE:$ROLE /usr/local/yugabyte

# fetch the binary
RUN curl -sSLo ./yugabyte.tar.gz https://downloads.yugabyte.com/releases/${YB_VERSION}/yugabyte-${YB_VERSION}-b${YB_BUILD}-linux-x86_64.tar.gz \
  && tar -xvf yugabyte.tar.gz -C $YB_BIN_PATH --strip-components=1 \
  && chmod +x $YB_BIN_PATH/bin/* \
  && rm ./yugabyte.tar.gz

# configure the interpreter
RUN ["/usr/local/yugabyte/bin/post_install.sh"]

# set the execution path and other env variables
ENV PATH="$YB_BIN_PATH/bin/:$PATH"
ENV HOST=127.0.0.1
ENV HOST_LB=127.0.0.1
ENV YSQL_PORT=5433
ENV YCQL_PORT=9042
ENV WEB_PORT=7000
ENV TSERVER_WEB_PORT=9000
ENV YCQL_API_PORT=12000
ENV YSQL_API_PORT=13000

EXPOSE ${YSQL_PORT} ${YCQL_PORT} ${WEB_PORT} ${TSERVER_WEB_PORT} ${YSQL_API_PORT} ${YCQL_API_PORT}
