FROM almalinux:8

ARG RUBY_VERSION=3.0.4
ARG NODEJS_VERSION=18.14.0
ADD data/repo/* /etc/yum.repos.d/

RUN dnf -y update \
&& dnf -y install epel-release \
&& dnf -y groupinstall "Development tools" \
&& dnf -y install \
glibc-locale-source \
glibc-langpack-ja \
wget \
ImageMagick \
ImageMagick-devel \
openssl-devel 
#&& dnf-config-manager --disable epel epel-modular \
RUN dnf -y install --enablerepo=mongodb-org-4.4,nginx mongodb-org nginx

#ENV LANG ja_JP.UTF-8
RUN localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
RUN echo 'LANG="ja_JP.UTF-8"' >  /etc/locale.conf
ENV LANG ja_JP.UTF-8

RUN echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock
RUN rm -f /etc/localtime
RUN ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN mkdir -p /var/cache/nginx/proxy_cache

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf
ENV LANG=C.UTF-8 PATH=/root/.asdf/bin:/root/.asdf/shims:$PATH

WORKDIR /root
RUN asdf plugin add ruby && \
asdf plugin add nodejs

RUN asdf install ruby ${RUBY_VERSION} \
&& asdf global ruby ${RUBY_VERSION} \
&& asdf install nodejs ${NODEJS_VERSION} \
&& asdf global nodejs ${NODEJS_VERSION} \
&& npm install -g yarn

CMD ["/usr/sbin/init"]

