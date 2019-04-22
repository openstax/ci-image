FROM python:3.7.0-stretch

# No interactive frontend during docker build
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true

ENV TERM=xterm

# Install pyenv
RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
ENV PATH "/root/.pyenv/bin:$PATH"
RUN eval "$(pyenv init -)"
RUN eval "$(pyenv virtualenv-init -)"

# Install rbenv and nodenv
RUN git clone https://github.com/rbenv/rbenv.git /root/.rbenv && \
    git clone https://github.com/rbenv/ruby-build.git /root/.rbenv/plugins/ruby-build && \
    git clone https://github.com/nodenv/nodenv.git /root/.nodenv && \
    git clone https://github.com/nodenv/node-build.git /root/.nodenv/plugins/node-build && \
    git clone https://github.com/nodenv/nodenv-package-rehash.git /root/.nodenv/plugins/nodenv-package-rehash && \
    git clone https://github.com/nodenv/nodenv-update.git /root/.nodenv/plugins/nodenv-update
ENV PATH /root/.rbenv/shims:/root/.rbenv/bin:/root/.nodenv/shims:/root/.nodenv/bin:$PATH

# Set the working dir
WORKDIR /code

# Install commonly used versions of python and node
RUN pyenv install 3.6.8 # cnx-recipes
RUN cd /root/.nodenv/plugins/node-build && git pull && cd - && nodenv install 10.15.3 # cnx-recipes

# Install dependencies for Chrome
# From https://github.com/GoogleChrome/puppeteer/blob/master/.ci/node8/Dockerfile.linux
RUN apt-get update && \
    apt-get -y install xvfb gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 \
      libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 \
      libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 \
      libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 \
      libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget && \
    rm -rf /var/lib/apt/lists/*
