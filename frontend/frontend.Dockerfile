FROM node:22-alpine as build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine AS ngi
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
