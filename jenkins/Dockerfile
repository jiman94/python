FROM docker.io/jenkins/jenkins:alpine

# Set labels
LABEL version="2.6"
LABEL description="Containerised Jenkins CI/CD Server With Plugins"

ARG BUILD_ID=""

ENV BUILD_ID ${BUILD_ID:-'0.0.0.0-boo!'}

#ENV JAVA_OPTS="-Dhudson.footerURL=https://saidsef.co.uk -Djenkins.install.runSetupWizard=false -Dhudson.remoting.ClassFilter=java.security.KeyPair,sun.security.rsa.RSAPrivateCrtKeyImpl -Dpermissive-script-security.enabled=true -Djdk.tls.client.protocols=TLSv1.2 -javaagent:/usr/share/jenkins/jmx_prometheus_javaagent.jar=8081:/var/jenkins_home/prometheus-jmx-config.yaml -Xms3g -Xmx3g -XX:MetaspaceSize=1024m -XX:MaxMetaspaceExpansion=128m -XX:MaxMetaspaceSize=2048m -Xss2048k -XX:MaxDirectMemorySize=512m"

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Dhudson.remoting.ClassFilter=java.security.KeyPair,sun.security.rsa.RSAPrivateCrtKeyImpl -Dpermissive-script-security.enabled=true -Djdk.tls.client.protocols=TLSv1.2 -Xms3g -Xmx3g -XX:MetaspaceSize=1024m -XX:MaxMetaspaceExpansion=128m -XX:MaxMetaspaceSize=2048m -Xss2048k -XX:MaxDirectMemorySize=512m"

ENV PROMETHEUS_JMX_JAR_VERSION 0.16.1
ENV PORT ${PORT:-8080}

# Copy plugins, groovy and css to container
COPY files/plugins.txt /var/jenkins_home/plugins.txt
COPY groovy/custom.groovy /var/jenkins_home/init.groovy.d/
COPY files/prometheus-jmx-config.yaml /var/jenkins_home

# Disable plugin banner on startup
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

USER root

RUN apk --no-cache add curl graphviz && \
    curl -vSL https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${PROMETHEUS_JMX_JAR_VERSION}/jmx_prometheus_javaagent-${PROMETHEUS_JMX_JAR_VERSION}.jar -o /usr/share/jenkins/jmx_prometheus_javaagent.jar && \
    chown jenkins:jenkins -R /usr/share/jenkins && \
    chown jenkins:jenkins -R /var/jenkins_home

#
#RUN curl -vSL https://services.gradle.org/distributions/gradle-7.3.1-bin.zip -o gradle-7.3.1 && \
#    chown jenkins:jenkins -R /opt/gradle/gradle-7.3.1 && \

ENV PATH=$PATH:/opt/gradle/gradle-7.3.1/bin
RUN mkdir /opt/gradle \
    && wget -q https://services.gradle.org/distributions/gradle-7.3.1-bin.zip \
    && unzip gradle-7.3.1-bin.zip -d /opt/gradle/ \
    && rm -f gradle-7.3.1-bin.zip

RUN gradle -v 
RUN java --version
RUN 

RUN which java
RUN which gradle

USER jenkins

# Install plugins
RUN /usr/local/bin/install-plugins.sh < /var/jenkins_home/plugins.txt

RUN echo ${BUILD_ID} | tee -a /tmp/build_id.txt

# Health check endpoint
HEALTHCHECK --interval=30s --timeout=10s CMD curl --fail 'http://localhost:${PORT}/login?from=login' || exit 1

EXPOSE ${PORT} 8081
