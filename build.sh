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

VERSION=${VERSION:="0.0.2-SNAPSHOT"}
docker pull $(grep FROM Dockerfile | grep distroless | cut -d ' ' -f 2-)
docker build --no-cache -t "sensinact:$VERSION" --build-arg "version=$VERSION" .
