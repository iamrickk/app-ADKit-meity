FROM cirrusci/flutter:stable

WORKDIR /app

COPY . /app

# RUN flutter pub upgrade

RUN flutter pub get

RUN flutter build apk --release

EXPOSE 8080

# Run the Flutter app when the container starts
CMD ["flutter", "run", "--release", "--no-sound-null-safety", "--web-port", "8080"]
