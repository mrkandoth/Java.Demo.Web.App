# Stage 1: Build the application
FROM gradle:8.1.1-jdk11 as build
WORKDIR /app
COPY build.gradle settings.gradle gradlew ./
COPY gradle ./gradle
# RUN ./gradlew dependencies
COPY . .
RUN ./gradlew build --no-daemon

# Stage 2: Build the production image
FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=build /app/build/libs/rest-service.jar ./rest-service.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "rest-service.jar"]
