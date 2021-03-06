FROM clojure:tools-deps-1.10.1.716-slim-buster

RUN mkdir -p /usr/src/flureedb
WORKDIR /usr/src/flureedb

COPY deps.edn Makefile ./
RUN make deps

COPY . ./

RUN make jar

# Create a user to own the fluree code
RUN groupadd fluree && useradd --no-log-init -g fluree -m fluree

# move clj deps to fluree's home
# double caching in image layers is unfortunate, but setting this user
# earlier in the build caused its own set of issues
RUN mv /root/.m2 /home/fluree/.m2 && chown -R fluree.fluree /home/fluree/.m2

RUN chown -R fluree.fluree .
USER fluree

ENTRYPOINT []
