FROM node:18
WORKDIR /blog
ADD blog /blog
RUN npm install hexo-cli -g \
    && npm install \
    && hexo g
EXPOSE 4000
CMD hexo s