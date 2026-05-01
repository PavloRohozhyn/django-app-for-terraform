FROM python:3.10-slim

WORKDIR /app

# Встановлюємо залежності
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо проект
COPY src/ .
COPY entrypoint.sh .

# Робимо скрипт виконуваним
RUN chmod +x entrypoint.sh
ENTRYPOINT ["sh", "/app/entrypoint.sh"]