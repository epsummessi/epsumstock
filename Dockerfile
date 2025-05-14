# ---- BUILD STAGE ----
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /app

# Copy Gradle wrapper and permission fix
COPY gradlew .
COPY gradle gradle
RUN chmod +x gradlew

# Copy project files
COPY . .

# Build the application (skip tests and checks)
RUN ./gradlew clean build -x test -x check

# ---- RUNTIME STAGE ----
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Set active Spring profile (prod)
ENV SPRING_PROFILES_ACTIVE=prod

# Set default port in case PORT isn't injected by Render
ENV PORT=8080

# Copy the built jar
COPY --from=build /app/build/libs/*.jar app.jar

# Expose the port (optional, Render handles it automatically)
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]