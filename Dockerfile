# ------------------------------
# Stage 1: Build the application
# ------------------------------
FROM gradle:8.10.0-jdk21 AS build

# Set the working directory inside the container
WORKDIR /home/gradle/project

# Copy only the Gradle wrapper and build files first (for caching)
COPY build.gradle settings.gradle gradlew ./
COPY gradle gradle

# Download dependencies (this layer is cached if no changes)
RUN ./gradlew dependencies --no-daemon

# Copy the actual source code
COPY src src

# Build the application (creates a JAR file)
RUN ./gradlew clean build -x test --no-daemon


# ------------------------------
# Stage 2: Run the application
# ------------------------------
FROM openjdk:21-jdk-slim

# Set working directory
WORKDIR /app

# Copy the built JAR from the previous stage
COPY --from=build /home/gradle/project/build/libs/*.jar app.jar

# Expose the port your app runs on
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
