# Copyright (c) 2022-2023, AllWorldIT.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.


FROM registry.conarx.tech/containers/alpine/edge



ARG VERSION_INFO=
LABEL org.opencontainers.image.authors   = "Nigel Kukard <nkukard@conarx.tech>"
LABEL org.opencontainers.image.version   = "edge"
LABEL org.opencontainers.image.base.name = "registry.conarx.tech/containers/alpine/edge"


ENV FDC_DISABLE_SUPERVISORD=true


RUN set -eux; \
	true "Docker"; \
	apk add --no-cache \
		btrfs-progs \
		curl \
		docker \
		e2fsprogs \
		e2fsprogs-extra \
		ip6tables \
		iptables \
		openssl \
		pigz \
		py3-pip \
		shadow-uidmap \
		xfsprogs \
		xz \
		\
		docker-cli-buildx \
		docker-py \
		py3-certifi \
		py3-charset-normalizer \
		py3-idna \
		py3-six \
		py3-urllib3 \
		py3-websocket-client \
		; \
	true "Cleanup"; \
	rm -f /var/cache/apk/*


# Install docker-squash and remove health checking as this is not a daemon
RUN set -eux; \
	pip install --use-pep517 docker-squash; \
	rm -f /usr/local/share/flexible-docker-containers/tests.d/40-crond.sh; \
	rm -f /usr/local/share/flexible-docker-containers/tests.d/90-healthcheck.sh


# Docker
COPY usr/local/share/flexible-docker-containers/tests.d/42-docker.sh /usr/local/share/flexible-docker-containers/tests.d
RUN set -eux; \
	true "Flexible Docker Containers"; \
	if [ -n "$VERSION_INFO" ]; then echo "$VERSION_INFO" >> /.VERSION_INFO; fi; \
	fdc set-perms
