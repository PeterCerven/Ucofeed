# Build stage
FROM amazoncorretto:21-alpine-jdk AS build
WORKDIR /app
COPY mvnw pom.xml ./
COPY .mvn .mvn
RUN ./mvnw dependency:go-offline
COPY . .
RUN ./mvnw clean package


# Runtime stage
FROM amazoncorretto:21-alpine-jdk
WORKDIR /app
COPY --from=build /app/target/backend-*-SNAPSHOT.jar ./app.jar
RUN apk add --no-cache curl
ENTRYPOINT ["java", "-jar", "app.jar"]
