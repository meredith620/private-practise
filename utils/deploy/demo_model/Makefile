INSTALL := install
MKDIR := mkdir -p
RMCMD := rm -rf

REDIS := redis
PREFIX := RXINSTALL_ROOT
BIN_PATH := RXBIN_PATH
CONF_PATH := RXCONF_PATH_PREFIX_RID
LOG_PATH := RXLOG_PATH
SCRIPT_PATH := RXSCRIPT_PATH

install:
	$(INSTALL) -m 755 redis-server -D $(PREFIX)/$(BIN_PATH)/redis-server
	$(INSTALL) -m 755 redis-cli -D $(PREFIX)/$(BIN_PATH)/redis-cli
	$(INSTALL) -m 644 redis.conf -D $(PREFIX)/$(CONF_PATH)/redis.conf

	$(INSTALL) -m 644 librediscmd_sh -D $(PREFIX)/$(SCRIPT_PATH)/librediscmd_sh
	$(INSTALL) -m 755 save_node.sh -D $(PREFIX)/$(SCRIPT_PATH)/save_node.sh
	$(INSTALL) -m 755 start_node.sh -D $(PREFIX)/$(SCRIPT_PATH)/start_node.sh
	$(INSTALL) -m 755 stop_node.sh -D $(PREFIX)/$(SCRIPT_PATH)/stop_node.sh
	$(INSTALL) -m 755 check_node.sh -D $(PREFIX)/$(SCRIPT_PATH)/check_node.sh
	$(INSTALL) -m 755 send_redis_cmd.sh -D $(PREFIX)/$(SCRIPT_PATH)/send_redis_cmd.sh
	$(INSTALL) -m 755 config_set.sh -D $(PREFIX)/$(SCRIPT_PATH)/config_set.sh
	$(INSTALL) -m 644 redis_cmd -D $(PREFIX)/$(SCRIPT_PATH)/redis_cmd
	cat rx5_conf >> $(PREFIX)/$(SCRIPT_PATH)/rx5.conf

	$(MKDIR) $(PREFIX)/$(LOG_PATH)

clear:
	$(RMCMD) $(PREFIX)/$(SCRIPT_PATH)

uninstall:
	if [ ! -d $(PREFIX)/$(BIN_PATH) ];then exit -1;fi
	$(RMCMD) $(PREFIX)/$(SCRIPT_PATH)

deep_uninstall:
	$(RMCMD) $(PREFIX)/$(BIN_PATH)
	$(RMCMD) $(PREFIX)/$(CONF_PATH)
	$(RMCMD) $(PREFIX)/$(LOG_PATH)
	$(RMCMD) $(PREFIX)/$(SCRIPT_PATH)

debug:
	@echo -e "===== \033[1;33mDEBUG INFO\033[0m ====="
	@echo -e "\033[1;32minstall:\033[0m"
	@echo -e "\t$(INSTALL) -m 755 redis-server -D $(PREFIX)/$(BIN_PATH)/redis-server"
	@echo -e "\t$(INSTALL) -m 755 redis-cli -D $(PREFIX)/$(BIN_PATH)/redis-cli"
	@echo -e "\t$(INSTALL) -m 644 redis.conf -D $(PREFIX)/$(CONF_PATH)/redis.conf"
	@echo -e "\t$(INSTALL) -m 644 librediscmd_sh -D $(PREFIX)/$(SCRIPT_PATH)/librediscmd_sh"
	@echo -e "\t$(INSTALL) -m 755 save_node.sh -D $(PREFIX)/$(SCRIPT_PATH)/save_node.sh"
	@echo -e "\t$(INSTALL) -m 755 start_node.sh -D $(PREFIX)/$(SCRIPT_PATH)/start_node.sh"
	@echo -e "\t$(INSTALL) -m 755 stop_node.sh -D $(PREFIX)/$(SCRIPT_PATH)/stop_node.sh"
	@echo -e "\t$(INSTALL) -m 755 check_node.sh -D $(PREFIX)/$(SCRIPT_PATH)/check_node.sh"
	@echo -e "\t$(INSTALL) -m 755 send_redis_cmd.sh -D $(PREFIX)/$(SCRIPT_PATH)/send_redis_cmd.sh"
	@echo -e "\t$(INSTALL) -m 644 redis_cmd -D $(PREFIX)/$(SCRIPT_PATH)/redis_cmd"
	@echo -e "\tcat rx5_conf >> $(PREFIX)/$(SCRIPT_PATH)/rx5.conf"
	@echo -e "\t$(MKDIR) $(PREFIX)/$(LOG_PATH)"

	@echo -e "\033[1;35mclear:\033[0m"
	@echo -e "\t$(RMCMD) $(PREFIX)/$(SCRIPT_PATH)/rx5.conf"

	@echo -e "\033[1;31muninstall:\033[0m"
	@echo -e "\tif [ ! -d $(PREFIX)/$(BIN_PATH) ];then exit -1;fi"
	@echo -e "\t$(RMCMD) $(PREFIX)/$(CONF_PATH)"

	@echo -e "\033[1;36mdeep_uninstall: uninstall\033[0m"
	@echo -e "\t$(RMCMD) $(PREFIX)/$(BIN_PATH)"
	@echo -e "\t$(RMCMD) $(PREFIX)/$(CONF_PATH)"
	@echo -e "\t$(RMCMD) $(PREFIX)/$(LOG_PATH)"
	@echo -e "\t$(RMCMD) $(PREFIX)/$(SCRIPT_PATH)"

.PHONY: install uninstall deep_uninstall clear
