# Get latest official python 3 image
FROM python:3

# Set docker working directory
WORKDIR /src

# Update environment
RUN apt-get -qq update
RUN apt-get -qq -y install curl cython

ENV GDAL_VERSION=2.2.1

# Install GDAL
RUN wget http://download.osgeo.org/gdal/$GDAL_VERSION/gdal-${GDAL_VERSION}.tar.gz -O /tmp/gdal-${GDAL_VERSION}.tar.gz && tar -x -f /tmp/gdal-${GDAL_VERSION}.tar.gz -C /tmp

RUN cd /tmp/gdal-${GDAL_VERSION} && \
    ./configure \
        --prefix=/usr \
        --with-python \
        --with-geos \
        --with-sfcgal \
        --with-geotiff \
        --with-jpeg \
        --with-png \
        --with-expat \
        --with-libkml \
        --with-openjpeg \
        --with-pg \
        --with-curl \
        --with-spatialite && \
    make -j $(nproc) && make install

RUN rm /tmp/gdal-${GDAL_VERSION} -rf

RUN apt-get -y install libgeos-dev
RUN pip3 install uwsgi shapely
RUN apt-get -y install python-numpy python-scipy

# Copy requirements to docker image
COPY requirements.txt /tmp/requirements.txt

# Pip install from requirements file
RUN pip3 install -r /tmp/requirements.txt


