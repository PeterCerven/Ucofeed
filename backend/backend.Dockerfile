# Build stage
FROM amazoncorretto:21-alpine-jdk as build
WORKDIR /app
COPY mvnw pom.xml ./
COPY .mvn .mvn
RUN ./mvnw dependency:go-offline -B
COPY . .
RUN ./mvnw clean package -DskipTests


# Runtime stage
FROM amazoncorretto:21-alpine-jdk
RUN apk add --no-cache curl # Curl for healthcheck
WORKDIR /app
COPY --from=build /app/target/backend-*-SNAPSHOT.jar ./backend.jar
ENTRYPOINT ["java", "-jar", "backend.jar"]