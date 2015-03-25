FROM ubuntu:14.10

MAINTAINER Morten V. Pedersen <morten@mortenvp.com>

RUN apt-get update && apt-get install -y \
  make \
  python-dev \
  python-pip \
  python-matplotlib \
  python-pandas \
  pandoc

# The following commands will install specific versions using pip. It would
# be preferable to install everything using apt-get but at the time of
# writing there were the following incompatabilities:
#
# 1) IPython 3.0 was not compatible with the Pelican liquid_tags plug-in
#    needed to import ipython notebooks
#
# 2) Markdown version > 2.4 contained a bug that resulted in
#    an "incompatible format" error.
#
# It would be great to play with newer versions at a later point in time.
# If you do and it works and it works let me know <morten@mortenvp.com> :)

RUN pip install pelican==3.4.0 ipython==2.3.0 Markdown==2.4.0

# We should expose our pelican site to the container
# docker run -P -v /home/mortenvp/dev/mortenvp-pelican /mortenvp-pelican
WORKDIR /mortenvp-pelican

# The pelican command `make devserver` will monitor the source files and
# automatically reload when files change. An internal webserver is started
# on http://localhost:8000 so can expose this port outside the container.
EXPOSE 8000:8000

# The tail part is just needed to make sure that the process "hangs" inside
# the container
CMD make devserver && tail -F pelican.pid