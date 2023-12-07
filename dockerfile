# Use Python >= 3.6
FROM python:3.8

# Set environment variables
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

COPY requirements.txt /

RUN apt-get update && apt-get install ffmpeg libsm6 libxext6 libgl1 -y

RUN pip3.8 install --no-cache-dir -r requirements.txt

COPY ./ADKit /

EXPOSE 8000

# Run Django app
CMD ["python3.8", "manage.py", "runserver", "0.0.0.0:8000"]
