#####################################################################
# Copyright (c) 2024 Kentyou
#
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Kentyou - initial implementation
######################################################################

# First stage: download and unzip the Eclipse sensiNact distribution
FROM amd64/maven:3.9-eclipse-temurin-17 AS maven-amd64

FROM arm64v8/maven:3.9-eclipse-temurin-17 AS maven-arm64

FROM arm32v7/maven:3.9-eclipse-temurin-17 AS maven-arm

FROM maven-${TARGETARCH} AS dl

ARG version=0.0.2-SNAPSHOT

RUN apt update && apt install -y unzip && apt clean
RUN mvn dependency:get \
    -DremoteRepositories="https://repo.eclipse.org/content/groups/sensinact/" \
    -Dartifact="org.eclipse.sensinact.gateway.distribution:assembly:${version}:zip"
RUN mvn dependency:copy \
    -Dartifact="org.eclipse.sensinact.gateway.distribution:assembly:${version}:zip" \
    -DoutputDirectory=/opt/
RUN unzip "/opt/assembly-*.zip" -d /opt/sensinact && \
    chmod +x /opt/sensinact/start.sh

# ------------------------------------------------------------------------------
# Second stage: minimal image to run Eclipse sensiNact
FROM amd64/eclipse-temurin:17-jre-noble AS amd64

FROM arm64v8/eclipse-temurin:17-jre-noble AS arm64

FROM arm32v7/eclipse-temurin:17-jre-noble AS arm

FROM $TARGETARCH AS build

LABEL org.opencontainers.image.source="https://github.com/kentyou/eclipse-sensinact-container"

COPY --from=dl /opt/sensinact /opt/sensinact
WORKDIR /opt/sensinact/
ENTRYPOINT [ "java", "-Dsensinact.config.dir=configuration", "-jar", "launch/launcher.jar" ]
