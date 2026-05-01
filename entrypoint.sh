#!/bin/sh
set -e
export PYTHONPATH=$PYTHONPATH:/app
echo "Running migrations..."
python app/manage.py migrate --noinput
echo "Starting Gunicorn..."
exec gunicorn --bind 0.0.0.0:8000 app.app.wsgi:application