#!/bin/bash
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

IMAGE=${IMAGE:-"ghcr.io/kentyou/eclipse-sensinact-container/sensinact"}
VERSION=${VERSION:="0.0.2-SNAPSHOT"}
for base in $(grep FROM Dockerfile | cut -d ' ' -f 2 )
do
    docker pull "$base"
done
docker build --no-cache -t "$IMAGE:$VERSION" --build-arg "version=$VERSION" .
