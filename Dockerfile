# --- Build Stage ---
FROM python:3.11-slim-bookworm AS build
WORKDIR /opt/CTFd

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libffi-dev \
    libssl-dev \
    libpq-dev \
    default-libmysqlclient-dev \
    pkg-config \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY . /opt/CTFd

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir psycopg2 mysqlclient pymysql

# --- Runtime Stage ---
FROM python:3.11-slim-bookworm AS release
WORKDIR /opt/CTFd

RUN apt-get update && apt-get install -y --no-install-recommends \
    libffi8 \
    libssl3 \
    libpq5 \
    libmariadb3 \
    ca-certificates \
    nano \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create user and required writable directories
RUN useradd -u 1001 -m ctfd && \
    mkdir -p /var/log/CTFd /var/uploads /opt/CTFd/.data && \
    chown -R 1001:1001 /var/log/CTFd /var/uploads /opt/CTFd/.data

# Copy application files
COPY --chown=1001:1001 . /opt/CTFd
COPY --chown=1001:1001 --from=build /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"
RUN chmod +x /opt/CTFd/docker-entrypoint.sh

USER 1001
EXPOSE 8000
ENTRYPOINT ["/opt/CTFd/docker-entrypoint.sh"]