#!/bin/bash

# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
set -x

SCRIPT_DIR=$(dirname $(readlink -f $0 2>/dev/null) 2>/dev/null || echo "${PWD}/$(dirname $0)")

# Install Docker
${SCRIPT_DIR}/install_docker_ubuntu2004.sh

# Pull images
${SCRIPT_DIR}/pull_docker_images.sh ${SCRIPT_DIR}/image_list.txt

# Remove installer files
[[ ${SCRIPT_DIR} != "/" ]] && rm -rf ${SCRIPT_DIR}
