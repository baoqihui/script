FROM node:18
WORKDIR /blog
ADD blog /blog
RUN npm install hexo-cli -g \
    && npm install
EXPOSE 4000
CMD hexo g&&hexo s