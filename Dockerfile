# FROM ubuntu
FROM richardking/ubuntu-nginx-2.1.1-bundle

# RUN apt-get update -q
# RUN apt-get install -qy nginx
# RUN apt-get install -qy curl
# RUN apt-get install -qy git
# RUN apt-get install -qy nodejs
# RUN apt-get install -qy postgresql
# RUN apt-get install -qy libpq-dev
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Install rvm, ruby, bundler
# RUN curl -sSL https://get.rvm.io | bash -s stable
# RUN /bin/bash -l -c "rvm requirements"
# RUN /bin/bash -l -c "rvm install 2.1.1"
# RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"



# Add configuration files in repository to filesystem
ADD config/container/nginx-sites.conf /etc/nginx/sites-enabled/default
ADD config/container/start-server.sh /usr/bin/start-server
# ADD config/database.example.yml config/database.yml
RUN chmod +x /usr/bin/start-server

# Add rails project to project directory
ADD ./ /rails

# set WORKDIR
WORKDIR /rails

# bundle install
RUN /bin/bash -l -c "bundle install"
# RUN /bin/bash -l -c "rake db:migrate"

# Publish port 80
EXPOSE 80

# Startup commands
# ENTRYPOINT ["/usr/bin/start-server"]
CMD ["/usr/bin/start-server"]
