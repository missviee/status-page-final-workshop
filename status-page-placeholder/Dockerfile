#THIS IS FOR CI/CD ONLY
FROM python:3.11-slim
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 8000
CMD ["python", "statuspage/manage.py", "runserver", "0.0.0.0:8000"]

