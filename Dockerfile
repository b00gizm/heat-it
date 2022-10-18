FROM node:16-alpine AS dev

WORKDIR /workspace

COPY package.json yarn.lock tsconfig.json tsconfig.build.json /workspace/
COPY src /workspace/src
RUN yarn install

FROM node:16-alpine AS builder

WORKDIR /workspace

COPY --from=dev /workspace/package.json /workspace/yarn.lock /workspace/tsconfig.json /workspace/tsconfig.build.json /workspace/
COPY --from=dev /workspace/src /workspace/src
RUN yarn global add @nestjs/cli \
  && yarn install --production --frozen-lockfile \
  && yarn build

FROM node:16-alpine AS production

WORKDIR /app

COPY --from=builder /workspace/dist /app/dist
COPY --from=builder /workspace/node_modules /app/node_modules

EXPOSE 3000

CMD ["node", "dist/main.js"]