# ---- BUILD STAGE ----
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /app

# Copy Gradle wrapper files first for better caching
COPY gradlew .
COPY gradle gradle

# Give execution permission
RUN chmod +x gradlew

# Copy all project files
COPY . .

# Build the project and skip tests/checks for faster builds
RUN ./gradlew clean build -x test -x check

# ---- RUNTIME STAGE ----
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose the port (for local testing, Railway sets PORT)
EXPOSE 8484

# Run the app
CMD ["java", "-jar", "app.jar"]
