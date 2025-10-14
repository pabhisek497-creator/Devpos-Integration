# Use a lightweight JDK
FROM openjdk:21-jdk-slim

# Copy the Gradle-built jar
COPY build/libs/docker-learn-0.0.1.jar app.jar

# Expose port
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]

