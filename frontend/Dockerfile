# ================================
# Stage 1 : Build Angular
# ================================


# pars déjà sur une base très légère. L’image Node Alpine réduit la taille et les dépendances inutiles, ce qui rend l’étape de build plus efficace
# conteneur de construction est à la fois rapide et léger.
# En production, pas besoin de Node, juste le Nginx Alpine tout aussi minimal
# Node pour builder, Nginx pour servir


FROM node:20-alpine AS build

WORKDIR /app

# Copier package.json en premier pour profiter du cache Docker
# Le fichier package.json décrit ton projet, notamment les dépendances dont tu as besoin (par exemple les bibliothèques Angular, d’autres packages Node)

# npm ci = Elle supprime le dossier des modules s’il existe, puis installe exactement les versions figées dans le package-lock
# assure une installation reproductible, rapide et sans surprise.

COPY package.json package-lock.json ./
RUN npm ci



# Copier le code source et compiler
# il faut les transformer en quelque chose que le navigateur comprend.

COPY . .
RUN npm run build -- --configuration production





# ================================
# Stage 2 : Runtime Nginx
# ================================



# Nginx ici sert de serveur web pour la couche statique. Même sur Amazon, ce conteneur sera déployé et jouera ce rôle.
# l'infrastructure Amazon fournit l'environnement, mais à l’intérieur de cet environnement, ton conteneur avec Nginx distribuera tes fichiers Angular.
# Amazon, c’est l’hébergeur global, et Nginx, le serveur web qui répond aux requêtes web.

# Nginx, c’est un serveur web et proxy inverse
# il sert simplement des fichiers statiques, comme le HTML, le CSS ou le JavaScript générés par Angular.
# Comme proxy inverse, il peut faire transiter les requêtes vers un backend, par exemple une API.

FROM nginx:alpine




# Supprimer la config Nginx par défaut
# Nginx arrive avec une configuration par défaut qui n’est pas forcément adaptée à ton application
# En la supprimant, tu évites toute configuration inutile ou conflit.

RUN rm /etc/nginx/conf.d/default.conf

# Copier notre config Nginx personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf




# Copier le build Angular
# Angular 19 sort le build dans dist/frontend/browser
COPY --from=build /app/dist/frontend/browser /usr/share/nginx/html

# Port exposé par Nginx
EXPOSE 80



# Health check
# toutes les 30 secondes, Docker vérifie que Nginx répond bien.
# Si ça échoue plusieurs fois de suite (selon le nombre de tentatives), Docker considère que le conteneur est en mauvais état.
# En fonction de la configuration de ton orchestrateur (par exemple, Amazon ECS ou Kubernetes), il peut alors redémarrer le conteneur, assurant ainsi une meilleure disponibilité de ton application


HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]

