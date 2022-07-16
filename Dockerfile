FROM base_000_transform:latest

# RUN add-apt-repository universe multiverse

# RUN apt-get update -y
# RUN apt-get -y install wget ca-certificates libgdal26
# RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
# RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt focal-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
# RUN wget --quiet -O - http://security.ubuntu.com/ubuntu/pool/main/i/icu/libicu66_66.1-2ubuntu2_amd64.deb > /tmp/libicu66.deb
# RUN dpkg -i /tmp/libicu66.deb

# RUN apt-get update

# # RUN DEBIAN_FRONTEND=noninteractive apt-get -y 

# # RUN apt show postgresql-contrib
# RUN apt-get install -y postgresql-10 postgresql-10-postgis-2.4 postgresql-10-postgis-2.5-scripts postgresql-10-postgis-2.5


# https://medium.com/@mbaker/docker-postgis-and-pgsql2shp-shp2pgsql-293e1ad2429

RUN apt-get update -y
RUN apt-get -y install postgis


COPY src /etl/src
