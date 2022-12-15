FROM gradle:7.6.0-jdk11

ENV SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-9123335_latest.zip" \
    ANDROID_HOME="/usr/local/android-sdk" \
    ANDROID_VERSION=33 \
    ANDROID_BUILD_TOOLS_VERSION=33.0.1

RUN export ANDROID_HOME=$ANDROID_HOME

RUN mkdir "$ANDROID_HOME" .android \
    && cd "$ANDROID_HOME" \
    && curl -o sdk.zip $SDK_URL \
    && unzip sdk.zip \
    && rm sdk.zip
    #&& mkdir "$ANDROID_HOME/licenses" || true \
    #&& echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "$ANDROID_HOME/licenses/android-sdk-license" \
    #&& echo "84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"

RUN yes | $ANDROID_HOME/cmdline-tools/bin/sdkmanager --licenses --sdk_root=$ANDROID_HOME
RUN $ANDROID_HOME/cmdline-tools/bin/sdkmanager --update --sdk_root=$ANDROID_HOME
RUN $ANDROID_HOME/cmdline-tools/bin/sdkmanager --install --sdk_root=$ANDROID_HOME \
    "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"

COPY . /home/gradle
WORKDIR /home/gradle
#RUN gradle clean --debug