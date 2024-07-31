# Utilisez l'image de base officielle de Maven pour construire l'application
FROM maven:3.8.7-openjdk-17 AS build

# Définissez le répertoire de travail dans le conteneur
WORKDIR /app

# Copiez le fichier pom.xml et téléchargez les dépendances
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiez le reste des fichiers du projet
COPY src ./src

# Compilez l'application
RUN mvn package

# Utilisez l'image de base officielle OpenJDK pour exécuter l'application
FROM openjdk:17-jre-slim

# Définissez le répertoire de travail dans le conteneur
WORKDIR /app

# Copiez le fichier JAR de l'étape de construction précédente
COPY --from=build /app/target/*.jar app.jar

# Spécifiez la commande pour exécuter l'application
CMD ["java", "-jar", "app.jar"]
