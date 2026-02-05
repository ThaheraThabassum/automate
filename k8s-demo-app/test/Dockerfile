FROM python:3.11 AS builder

WORKDIR /app
COPY requirements.txt .
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt
    
FROM python:3.11-slim AS final

COPY --from=builder /opt/venv /opt/venv
WORKDIR /app
COPY app/ app/

ENV "PATH=/opt/venv/bin:$PATH"

EXPOSE 5000
CMD ["python", "app/app.py"]