# Stage 1: Build the application
FROM maven:3.9.1-eclipse-temurin-17-focal AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

# Stage 2: Build the production image
FROM eclipse-temurin:17-jre-focal
WORKDIR /app
COPY --from=build /app/target/demo-maven-0.0.1-SNAPSHOT.jar ./demomaven.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "demomaven.jar"]