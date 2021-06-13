#!/bin/bash
# Credit : https://github.com/teddysun/lamp
# Credit : https://github.com/docker-library/httpd

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

OPTION=$1
cur_dir=${PWD}

#define versions
export HTTPD_VERSION="2.4.48"
export APR_VERSION="1.7.0"
export APR_UTIL_VERSION="1.6.1"

#define locations
export apache_location="/usr/local/apache"
export web_root_dir="/data/www/default"
export website_root="/data/www/default"

get_help(){
printf "
Usage:
        Install Httpd : $0 -i
                        $0 --install

        Get     Help  : $0 -h
                        $0 --help
"
}

get_install(){
# install packages
sudo apt update
sudo apt install -y --no-install-recommends \
libaprutil1-ldap ca-certificates openssl dirmngr \
dpkg-dev gcc gnupg nghttp2 libapr1-dev libaprutil1-dev \
libbrotli-dev libcurl4-openssl-dev libjansson-dev \
liblua5.2-dev libnghttp2-dev libpcre3-dev libssl-dev \
libxml2-dev make wget zlib1g-dev lua-expat-dev

apache_configure_args="--prefix=${apache_location} \
--with-pcre=pcre \
--with-mpm=event \
--with-included-apr \
--with-ssl \
--with-nghttp2 \
--enable-modules=reallyall \
--enable-mods-shared=reallyall"

apache_configure_args=$(echo ${apache_configure_args})

#download httpd
wget https://archive.apache.org/dist/httpd/httpd-${HTTPD_VERSION}.tar.gz
tar -zxf httpd-${HTTPD_VERSION}.tar.gz && rm -rfv httpd-${HTTPD_VERSION}.tar.gz
mv httpd-${HTTPD_VERSION} httpd && cd httpd

#download apr && apr-util
wget -O srclib/apr.tar.gz https://archive.apache.org/dist/apr/apr-${APR_VERSION}.tar.gz
wget -O srclib/apr-util.tar.gz https://archive.apache.org/dist/apr/apr-util-${APR_UTIL_VERSION}.tar.gz
cd srclib
tar -zxf apr.tar.gz && tar -zxf apr-util.tar.gz
mv apr-${APR_VERSION} apr && mv apr-util-${APR_UTIL_VERSION} apr-util && rm -rf *.tar.gz

#install httpd
sudo groupadd apache && sudo useradd -M -s /sbin/nologin -g apache apache
mkdir -p ${web_root_dir} && sudo chmod -R 755 ${web_root_dir}

cd ${cur_dir}/httpd
./configure ${apache_configure_args} LDFLAGS=-ldl
make -j "$(nproc)"
make install

echo "----------------------------------------"
echo "----------------------------------------"
echo "                                        "
echo "                                        "
echo "        Install Successfully            "
echo "                                        "
echo "                                        "
echo "----------------------------------------"
echo "----------------------------------------"
}

get_setup(){
#config httpd
cd ${cur_dir} && rm -rfv httpd
if [ -f "${apache_location}/conf/httpd.conf" ]; then
    cp -f ${apache_location}/conf/httpd.conf ${apache_location}/conf/httpd.conf.bak >/dev/null 2>&1
fi

mv ${apache_location}/conf/extra/httpd-vhosts.conf ${apache_location}/conf/extra/httpd-vhosts.conf.bak
mkdir -p ${apache_location}/conf/ssl/
mkdir -p ${apache_location}/conf/vhost/
grep -qE "^\s*#\s*Include conf/extra/httpd-vhosts.conf" ${apache_location}/conf/httpd.conf && \
sed -i 's/^#\(LoadModule proxy_uwsgi_module\)/\1/' ${apache_location}/conf/httpd.conf
sed -i 's#^\s*\#\s*Include conf/extra/httpd-vhosts.conf#Include conf/extra/httpd-vhosts.conf#' ${apache_location}/conf/httpd.conf || \
sed -i '$aInclude conf/extra/httpd-vhosts.conf' ${apache_location}/conf/httpd.conf
sed -i 's/^User.*/User apache/i' ${apache_location}/conf/httpd.conf
sed -i 's/^Group.*/Group apache/i' ${apache_location}/conf/httpd.conf
sed -i 's/^#ServerName www.example.com:80/ServerName 0.0.0.0:80/' ${apache_location}/conf/httpd.conf
sed -i 's/^ServerAdmin you@example.com/ServerAdmin admin@localhost/' ${apache_location}/conf/httpd.conf
sed -i 's@^#Include conf/extra/httpd-info.conf@Include conf/extra/httpd-info.conf@' ${apache_location}/conf/httpd.conf
sed -i 's@DirectoryIndex index.html@DirectoryIndex index.html index.php@' ${apache_location}/conf/httpd.conf
sed -i "s@^DocumentRoot.*@DocumentRoot \"${web_root_dir}\"@" ${apache_location}/conf/httpd.conf
sed -i 's@#Include conf/extra/httpd-ssl.conf@Include conf/extra/httpd-ssl.conf@g' ${apache_location}/conf/httpd.conf
sed -i "s@^<Directory \"${apache_location}/htdocs\">@<Directory \"${web_root_dir}\">@" ${apache_location}/conf/httpd.conf
echo "ServerTokens ProductOnly" >> ${apache_location}/conf/httpd.conf
echo "ProtocolsHonorOrder On" >> ${apache_location}/conf/httpd.conf
echo "Protocols h2 h2c http/1.1" >> ${apache_location}/conf/httpd.conf

export HTTPD_SSL="https://raw.githubusercontent.com/teddysun/lamp/master/conf/httpd-ssl.conf"
wget -qO- ${HTTPD_SSL} > ${apache_location}/conf/extra/httpd-ssl.conf

mkdir -p /data/wwwlog/default ${website_root}
chown -R apache:apache /data/wwwlog/default ${website_root}

cat > ${apache_location}/conf/extra/httpd-vhosts.conf <<EOF
Include ${apache_location}/conf/vhost/*.conf
EOF

cat > ${apache_location}/conf/vhost/default.conf <<EOF
<VirtualHost *:443>
    ServerAdmin your@domain.com
    ServerName your.domain.com
    ServerAlias your.domain.com
    SSLEngine on
    SSLProxyEngine On
    SSLProxyVerify none
    SSLCertificateFile /etc/httpd_config/keys/server.pem
    SSLCertificateKeyFile /etc/httpd_config/keys/server.key
    <Proxy *>
       Order deny,allow
       Allow from all
    </Proxy>
    ProxyRequests Off
    <Location />
    ProxyPass http://localhost:8080/
    ProxyPassReverse http://localhost:8080/
    </Location>
</VirtualHost>
EOF

cat > ${website_root}/.htaccess << EOF
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [R,L]
</IfModule>
EOF

httpd_mod_list=(
mod_actions.so
mod_auth_digest.so
mod_auth_form.so
mod_authn_anon.so
mod_authn_dbd.so
mod_authn_dbm.so
mod_authn_socache.so
mod_authnz_fcgi.so
mod_authz_dbd.so
mod_authz_dbm.so
mod_authz_owner.so
mod_buffer.so
mod_cache.so
mod_cache_socache.so
mod_case_filter.so
mod_case_filter_in.so
mod_charset_lite.so
mod_data.so
mod_dav.so
mod_dav_fs.so
mod_dav_lock.so
mod_deflate.so
mod_echo.so
mod_expires.so
mod_ext_filter.so
mod_http2.so
mod_include.so
mod_info.so
mod_proxy.so
mod_proxy_connect.so
mod_proxy_fcgi.so
mod_proxy_ftp.so
mod_proxy_html.so
mod_proxy_http.so
mod_proxy_http2.so
mod_proxy_scgi.so
mod_ratelimit.so
mod_reflector.so
mod_request.so
mod_rewrite.so
mod_sed.so
mod_session.so
mod_session_cookie.so
mod_socache_dbm.so
mod_socache_memcache.so
mod_socache_shmcb.so
mod_speling.so
mod_ssl.so
mod_substitute.so
mod_suexec.so
mod_unique_id.so
mod_userdir.so
mod_vhost_alias.so
mod_xml2enc.so
)

for mod in ${httpd_mod_list[@]}; do
if [ -s "${apache_location}/modules/${mod}" ]; then
sed -i -r "s/^#(.*${mod})/\1/" ${apache_location}/conf/httpd.conf
fi
done

if [[ $(grep -Ec "^\s*LoadModule md_module modules/mod_md.so" ${apache_location}/conf/httpd.conf) -eq 0 ]] && \
   [[ -s "${apache_location}/modules/mod_md.so" ]]; then
lnum=$(sed -n '/LoadModule/=' ${apache_location}/conf/httpd.conf | tail -1)
sed -i "${lnum}aLoadModule md_module modules/mod_md.so" ${apache_location}/conf/httpd.conf
fi

rm -rfv /usr/sbin/httpd /var/log/httpd
ln -s ${apache_location}/bin/httpd /usr/sbin/httpd
ln -s ${apache_location}/logs /var/log/httpd

sudo apt-get purge -y libaprutil1-ldap dirmngr \
dpkg-dev gnupg libapr1-dev libaprutil1-dev \
libbrotli-dev libjansson-dev liblua5.2-dev \
libpcre3-dev libssl-dev libxml2-dev zlib1g-dev \
lua-expat-dev

echo "----------------------------------------"
echo "----------------------------------------"
echo "                                        "
echo "                                        "
echo "          Setup Successfully            "
echo "                                        "
echo "                                        "
echo "----------------------------------------"
echo "----------------------------------------"
}

if [ -z "$OPTION" ]; then
    echo "Please use --help to get help" && exit 1
else
    case "$OPTION" in
        -i|--install)
            get_install
			get_setup
            ;;
        -h|--help)
            get_help
            ;;
        *)
            echo "Unknown Options" && exit 1
            ;;
    esac
fi