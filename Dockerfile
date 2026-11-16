# Лёгкий nginx-alpine (~20 МБ), работает от non-root
FROM nginx:1.27-alpine

LABEL org.opencontainers.image.title="pregnancy-memo"
LABEL org.opencontainers.image.description="Памятка: близость и здоровые привычки при беременности"

# Убираем дефолтный конфиг и дефолтную страницу
RUN rm -rf /usr/share/nginx/html/* \
 && rm -f /etc/nginx/conf.d/default.conf

# Копируем свой конфиг и страницу
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html

# Права: отдаём файлы пользователю nginx (uid 101 в alpine)
RUN chown -R nginx:nginx /usr/share/nginx/html \
 && chown -R nginx:nginx /var/cache/nginx \
 && chown -R nginx:nginx /var/log/nginx \
 && touch /var/run/nginx.pid \
 && chown nginx:nginx /var/run/nginx.pid

USER nginx

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/ >/dev/null || exit 1

CMD ["nginx", "-g", "daemon off;"]
