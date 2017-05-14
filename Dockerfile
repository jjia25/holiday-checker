FROM elixir:1.4.2
ENV PORT=4000 MIX_ENV=prod

ENV APP_NAME=myapp APP_VERSION="0.1.0"

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mkdir /build

WORKDIR /build
COPY ./mix.exs /build
COPY ./mix.lock /build
COPY ./config /build/config
RUN mix do deps.get, deps.compile

COPY . /build
RUN mix do compile, release --verbose
# ADD _build/prod/rel/$APP_NAME .

RUN ln -s /build/_build/prod/rel/$APP_NAME /$APP_NAME

EXPOSE $PORT

WORKDIR /$APP_NAME
CMD trap exit TERM; /$APP_NAME/bin/$APP_NAME foreground & wait
