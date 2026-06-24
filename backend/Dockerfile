# ================================
# Stage 1 : Build
# ================================

# On prend maven avec le JDk temurin (open source)

FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app


# Copier le pom.xml en premier pour profiter du cache Docker
# Si le pom.xml ne change pas, Maven ne retélécharge pas les dépendances

COPY pom.xml .
RUN mvn dependency:go-offline -B


# Copier le code source et compiler
COPY src ./src
RUN mvn package -DskipTests -B


# ================================
# Stage 2 : Runtime
# ================================

# Ici plus besoin du JDK complet, on utilise juste le JRE pour exécuter l'app. C'est plus léger. 
# Il existe des variantes « Alpine » pour certains JRE. Alpine est une distribution très légère, ce qui peut réduire la taille de ton image finale.

FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

# Créer un utilisateur non-root pour la sécurité
RUN groupadd --system datashare && useradd --system --gid datashare datashare

# Copier uniquement le jar depuis le stage de build
COPY --from=build /app/target/backend-0.0.1-SNAPSHOT.jar  app.jar


# Donner les droits à l'utilisateur non-root
RUN chown datashare:datashare app.jar
USER datashare

# Port exposé par Spring Boot
EXPOSE 8080


# Health check pour Docker
# c’est une sorte de petit contrôle régulier. Ici, Docker va toutes les 30 secondes vérifier si ton appli répond bien
# Si ça échoue plusieurs fois de suite, Docker considère que ton conteneur n’est plus sain.
# Ça permet par exemple à des orchestrateurs comme Kubernetes de redémarrer ton conteneur s’il ne répond plus


HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

# Lancement
ENTRYPOINT ["java", "-jar", "app.jar"]



# ATTENTION ! 
# On peut également intégrer les tests : les tests assurent simplement que ton application fonctionne correctement avant de passer en production