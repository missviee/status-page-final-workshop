FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    DJANGO_SETTINGS_MODULE=statuspage.settings

WORKDIR /app/statuspage

RUN apt-get update && \
    apt-get install -y --no-install-recommends libpq5 && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel && \
    pip install -r requirements.txt

COPY . /app


EXPOSE 8000

CMD ["gunicorn", "statuspage.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]

