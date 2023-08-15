FROM tomcat:9
WORKDIR webapps
COPY --from=base /app/build/libs/sampleWeb-0.0.1-SNAPSHOT.war .
RUN rm -rf ROOT && mv sampleWeb-0.0.1-SNAPSHOT.war ROOT.war
# Stage 1: Build the Maven project
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src src
RUN mvn package

# Stage 2: Create the final image with Tomcat
FROM tomcat:9
WORKDIR webapps
COPY --from=build /app/target/ /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]
