FROM openjdk:8-jre-alpine

# Install bash
RUN apk add --update --no-cache bash

# Add the liquibase user and step in the directory
RUN addgroup -g 1001 liquibase
RUN adduser -D -u 1001 -G liquibase liquibase

# Make /liquibase directory and change owner to liquibase
RUN mkdir /liquibase && chown liquibase /liquibase
WORKDIR /liquibase

# Change to the liquibase user
USER liquibase

# Latest Liquibase Release Version
ARG LIQUIBASE_VERSION=4.0.0

# Download, verify, extract
ARG LB_SHA256=b51e852d81f19ed2146d8bdf55d755616772ce0defef66074de4f0b33dde971b
RUN set -x \
  && wget -O liquibase-${LIQUIBASE_VERSION}.tar.gz "https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz" \
  && echo "$LB_SHA256  liquibase-${LIQUIBASE_VERSION}.tar.gz" | sha256sum -c - \
  && tar -xzf liquibase-${LIQUIBASE_VERSION}.tar.gz

# Download JDBC library
ARG MYSQL_SHA256=f93c6d717fff1bdc8941f0feba66ac13692e58dc382ca4b543cabbdb150d8bf7
RUN wget -O /liquibase/lib/mysql.jar https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.19/mysql-connector-java-8.0.19.jar \
	&& echo "$MYSQL_SHA256  /liquibase/lib/mysql.jar" | sha256sum -c - 


ENTRYPOINT ["/liquibase/liquibase"]

CMD ["--help"]