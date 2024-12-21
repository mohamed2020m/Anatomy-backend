FROM node:20-alpine
WORKDIR /app
# Install dependencies
COPY package.json package-lock.json ./
RUN npm i
# Build Next.js app
COPY .env.example .env
COPY . .
# Expose port
EXPOSE 3000
# Start the application
CMD ["npm", "run", "dev"]
