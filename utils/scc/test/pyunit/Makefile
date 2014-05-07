test_cases = $(shell find . -name "unittest*.py")

pass := 0
fail := 0
total := 0
pass_list :=
fail_list :=

# $(call pass-one,cmd)
define pass-one
pass_list += $1
pass := $(shell echo $$(($(pass) + 1)))
total := $(shell echo $$(($(total) + 1)))
endef

# $(call fail-one,cmd)
define fail-one
fail_list += $1
fail := $(shell echo $$(($(fail) + 1)))
total := $(shell echo $$(($(total) + 1)))
endef

# $(happy-info,msg)
define happy-info
@echo -e "\033[32m $1 \033[m"
endef

# $(sad-info,msg)
define sad-info
@echo -e "\033[31m $1 \033[m"
endef

# $(call result)
define result
$(call happy-info,"pass: $(pass)")
$(call happy-info,"pass: $(pass_list)")
$(call sad-info,"fail: $(fail)")
$(call sad-info,"fail: $(fail_list)")
endef

# $(call judge,cmd,ret)
define judge
ifeq ($2,0)
	$(call pass-one,$1)
else
	$(call fail-one,$1)
endif
endef

# $(call run_one cmd)
define run_one
$(info "--- $1 ---")
$(eval RET := $(shell "./"$1; echo $$?))
$(eval $(call judge,$1,$(RET)))
$(info "")
endef

.PHONY: all
all:
	$(foreach one, $(test_cases), $(call run_one,$(one)))
	@echo "====="
	$(call result)

