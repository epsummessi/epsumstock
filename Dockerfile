# ---- BUILD STAGE ----
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /app

# 1. First copy ONLY the absolutely essential wrapper files
COPY gradlew .
COPY gradle/wrapper gradle/wrapper
COPY gradle/wrapper/gradle-wrapper.jar gradle/wrapper/
COPY gradle/wrapper/gradle-wrapper.properties gradle/wrapper/

# 2. Verify the wrapper files exist (debugging step)
RUN ls -la gradlew && \
    ls -la gradle/wrapper/

# 3. Make gradlew executable and verify
RUN chmod +x gradlew && \
    ./gradlew --version || { echo "Gradle wrapper verification failed"; ls -la gradle/wrapper/; exit 1; }

# 4. Now copy the rest of the application
COPY build.gradle .
COPY settings.gradle .
COPY src src

# 5. Build with clean cache
RUN ./gradlew clean build -x test -x check --no-daemon

# ---- RUNTIME STAGE ----
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
ENV SPRING_PROFILES_ACTIVE=prod PORT=8080
COPY --from=build /app/build/libs/*.jar app.jar
CMD ["java", "-jar", "app.jar"]