BASE_CONFIG_DIR := ./configs
GEN_CONFIG_DIR := ${BASE_CONFIG_DIR}/gen

.PHONY: gen-clickhouse-config
gen-clickhouse-config:
	rm -rf ${GEN_CONFIG_DIR} ; \
	mkdir -p ${GEN_CONFIG_DIR}/clickhouse-blue-1/config.d ; \
	mkdir -p ${GEN_CONFIG_DIR}/clickhouse-blue-2/config.d ; \
	mkdir -p ${GEN_CONFIG_DIR}/clickhouse-blue-1/users.d ; \
	mkdir -p ${GEN_CONFIG_DIR}/clickhouse-blue-2/users.d ;

	SERVER_ID=1 envsubst < ${BASE_CONFIG_DIR}/config.d/enable_keeper.xml > ${GEN_CONFIG_DIR}/clickhouse-blue-1/config.d/enable_keeper.xml
	REPLICA=r1 SHARD=blue envsubst < ${BASE_CONFIG_DIR}/config.d/macros.xml > ${GEN_CONFIG_DIR}/clickhouse-blue-1/config.d/macros.xml
	cp -t ${GEN_CONFIG_DIR}/clickhouse-blue-1/config.d/ ${BASE_CONFIG_DIR}/config.d/remote_servers.xml ${BASE_CONFIG_DIR}/config.d/use_keeper.xml ${BASE_CONFIG_DIR}/config.d/docker_related_config.xml; \
	cp -t ${GEN_CONFIG_DIR}/clickhouse-blue-1/users.d/ ${BASE_CONFIG_DIR}/users.d/user_settings.xml; \

	SERVER_ID=2 envsubst < ${BASE_CONFIG_DIR}/config.d/enable_keeper.xml > ${GEN_CONFIG_DIR}/clickhouse-blue-2/config.d/enable_keeper.xml
	REPLICA=r2 SHARD=blue envsubst < ${BASE_CONFIG_DIR}/config.d/macros.xml > ${GEN_CONFIG_DIR}/clickhouse-blue-2/config.d/macros.xml
	cp -t ${GEN_CONFIG_DIR}/clickhouse-blue-2/config.d/ ${BASE_CONFIG_DIR}/config.d/remote_servers.xml ${BASE_CONFIG_DIR}/config.d/use_keeper.xml ${BASE_CONFIG_DIR}/config.d/docker_related_config.xml; \
	cp -t ${GEN_CONFIG_DIR}/clickhouse-blue-2/users.d/ ${BASE_CONFIG_DIR}/users.d/user_settings.xml; \

.PHONY: up
up:
	docker-compose up

.PHONY: keeper-check
keeper-check:
	echo ruok | nc 127.0.0.1 9181
