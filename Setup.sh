#! / bin / bash
# #######################################################################################################################################################################################################################################################################################################
#                                            #
#             TEAM CLAY :V #
#                                            #
# #######################################################################################################################################################################################################################################################################################################

PHP_CONTAINER = " php-saycheese "
NGX_CONTAINER = " nginx-saycheese "
NGX_DOMAIN = " saycheese.kevops.xyz "

mkdir -p / var / containers / $ NGX_CONTAINER /etc/nginx/conf.d
mkdir -p / var / containers / share / var / www / html / {datos, imágenes}

clon de git https://github.com/kevop-s/Saycheese.git / opt / Saycheese
cp -rf / opt / Saycheese / src / * / var / containers / share / var / www / html /
chmod 777 -R / var / containers / share / var / www / html /
rm -rf / opt / Saycheese

cat << - EOF > /var/containers/$NGX_CONTAINER/etc/nginx/conf.d/$NGX_DOMAIN.conf
servidor {
    escucha 80;
    index index.php;
    nombre_servidor $ NGX_DOMAIN;
    root / var / www / html;
    localización / {
        try_files \ $ uri \ $ uri / = 404;
    }
    ubicación ~ \ .php $ {
        try_files \ $ uri = 404;
        fastcgi_split_path_info ^ (. + \. php) (/.+) $;
        fastcgi_pass php-fpm: 9000;
        incluir fastcgi_params;
        fastcgi_param SCRIPT_FILENAME / var / www / html \ $ fastcgi_script_name;
        fastcgi_param PATH_INFO \ $ fastcgi_path_info;
    }
}
EOF
sed " s% url: 'template_saycheese',% url: 'https: // $ {NGX_DOMAIN} /post.php',%g " /var/containers/share/var/www/html/zoom_cheese.html > / var /containers/share/var/www/html/index.html
sed -i " s% header. *% header ('Ubicación: https: // $ {NGX_DOMAIN} /index.html');%g " /var/containers/share/var/www/html/index.php

docker ejecutar -d --name $ PHP_CONTAINER \
    -v / var / containers / share / var / www / html: / var / www / html: z \
    -v / etc / localtime: / etc / localtime: ro \
    php: 7-fpm

docker run -td --nombre $ NGX_CONTAINER \
    -v / var / containers / share / var / www / html: / var / www / html: z \
    -v / var / contenedores / $ NGX_CONTAINER / var / log / nginx: / var / log / nginx: z \
    -v / var / containers / $ NGX_CONTAINER /etc/nginx/conf.d:/etc/nginx/conf.d:z \
    -v / etc / localtime: / etc / localtime: ro \
    -h $ NGX_CONTAINER .service \
    --enlace $ PHP_CONTAINER : php-fpm \
    nginx
