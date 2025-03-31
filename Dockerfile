FROM ghcr.io/expliyh/poetry

WORKDIR /app

WORKDIR /app/zhenxun

ENV TZ=Asia/Shanghai PYTHONUNBUFFERED=1
#COPY ./scripts/docker/start.sh /start.sh
#RUN chmod +x /start.sh

EXPOSE 8080

RUN apt update && \
    apt install -y --no-install-recommends curl fontconfig fonts-noto-color-emoji build-essential \
    && apt clean \
    && fc-cache -fv \
    && rm -rf /var/lib/apt/lists/*

# 复制依赖项和应用代码
COPY . .

RUN poetry install

RUN playwright install --with-deps chromium \
  && rm -rf /var/lib/apt/lists/* /tmp/*

COPY --from=metadata-stage /tmp/VERSION /app/VERSION

VOLUME ["/app/data", "/app/resources", "/app/log"]

CMD ["poetry", "run", "python", "bot.py"]
