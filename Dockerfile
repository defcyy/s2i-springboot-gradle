# springboot-gradle-centos7
FROM openshift/base-centos7

# TODO: Put the maintainer name in the image metadata
# LABEL maintainer="defcyy@gmail.com"

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV BUILDER_VERSION 1.0

ENV GRADLE_VERSION 4.8

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building springboot with gradle" \
     io.k8s.display-name="Springboot Gradle Builder" \
     io.openshift.expose-services="8080:http" \
     io.openshift.tags="builder,gradle-4.10.2,springboot"

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
RUN yum install -y curl unzip java-1.8.0-openjdk java-1.8.0-openjdk-devel && yum clean all -y && \
    curl -sL -0 https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip /tmp/gradle-${GRADLE_VERSION}-bin.zip -d /usr/local/ && \
    rm /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    mv /usr/local/gradle-${GRADLE_VERSION} /usr/local/gradle && \
    ln -sf /usr/local/gradle/bin/gradle /usr/local/bin/gradle && \
    mkdir -p /opt/openshift && \
    mkdir -p /opt/app-root/source && chmod -R a+rwX /opt/app-root/source && \
    mkdir -p /opt/s2i/destination && chmod -R a+rwX /opt/s2i/destination && \
    mkdir -p /opt/app-root/src && chmod -R a+rwX /opt/app-root/src

ENV PATH=/opt/gradle/bin/:$PATH

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/openshift

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]
