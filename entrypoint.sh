#!/bin/sh
set -e
echo "migration migrate ..."
python app/manage.py migrate --noinput
echo "run Gunicorn..."
exec gunicorn --bind 0.0.0.0:8000 app.wsgi:application