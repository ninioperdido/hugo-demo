FROM klakegg/hugo:0.92.1-alpine AS hugo
RUN apk add -U git
RUN hugo new site quickstart
RUN cd quickstart && \
    git init && \
    git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke && \
    mkdir -p content/posts
# Default config
RUN echo -n "# Site settings \n\
baseURL = \"/\" \n\
languageCode = \"en-us\" \n\
title = \"Hugo Demo\" \n\
theme = \"ananke\" \n" > quickstart/config.toml
# Some content
RUN echo -n "\n---\n\
title: \"My First Post\" \n\
date: 2019-03-26T08:47:11+01:00 \n\
draft: true \n\
---\n\n\
Hello \n" >> quickstart/content/posts/my-first-post.md
RUN cd quickstart && hugo
FROM nginx:alpine
COPY --from=hugo /src/quickstart/public /usr/share/nginx/html
EXPOSE 80
