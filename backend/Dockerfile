# Build stage
FROM amazoncorretto:21-alpine-jdk AS build
WORKDIR /app
COPY mvnw pom.xml ./
COPY .mvn .mvn
RUN chmod +x ./mvnw
RUN ./mvnw dependency:go-offline
COPY . .
RUN chmod +x ./mvnw
RUN ./mvnw clean package -DskipTests


# Runtime stage
FROM amazoncorretto:21-alpine-jdk
WORKDIR /app
COPY --from=build /app/target/backend-*-SNAPSHOT.jar ./app.jar
RUN apk add --no-cache curl
ENTRYPOINT ["java", "-jar", "app.jar"]
