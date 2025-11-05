# -------- Stage 1: Build dependencies --------
FROM python:3.10-slim as builder
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc libpq-dev && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# -------- Stage 2: Runtime image --------
FROM python:3.10-slim

# Create non-root user
RUN adduser --disabled-password --gecos '' appuser

WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH"

# Copy installed virtualenv and source code
COPY --from=builder /opt/venv /opt/venv
COPY . .

# Create logs directory and give ownership to appuser
RUN mkdir -p /app/logs && chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8000

# Start Gunicorn
CMD ["gunicorn", "notesapp.wsgi:application", "--bind", "0.0.0.0:8000"]
