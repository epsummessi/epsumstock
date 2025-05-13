# Build stage
FROM eclipse-temurin:21-jdk-jammy as builder

WORKDIR /app

# Copy Gradle wrapper files first (these rarely change)
COPY gradlew .
COPY gradle/wrapper gradle/wrapper
COPY gradle.properties .

# Copy build configuration
COPY build.gradle .
COPY settings.gradle .

# Download dependencies (cached unless build.gradle changes)
RUN ./gradlew dependencies

# Copy application source
COPY src src

# Build the application
RUN ./gradlew clean build -x test

# Runtime stage
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

# Copy the built application
COPY --from=builder /app/build/libs/*.jar app.jar

# Set production profile
ENV SPRING_PROFILES_ACTIVE=prod

EXPOSE ${PORT:-8484}

ENTRYPOINT ["java", "-jar", "app.jar"]