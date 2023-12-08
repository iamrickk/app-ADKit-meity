FROM ubuntu:latest
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

#Installing Android SDK
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.3" "platform-tools" "platforms;android-33" "sources;android-33"
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"

#Installing Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"
RUN flutter upgrade
RUN flutter doctor
RUN flutter devices

COPY ./ /home/developer/

CMD ["flutter", "run"]