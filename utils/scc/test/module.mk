# module mk, include basic info

## ========= build everything =============
local_cflags := #pass only to c compiler
local_cxxflags := -lpthread #pass only to c++ compiler
local_cppflags := #pass to both c & c++ compiler
local_ldflags :=
# ----- robot doing -----
build_options := "CFLAGS+=$(local_cflags) CXXFLAGS+=$(local_cxxflags) CPPFLAGS+=$(local_cppflags) LDFLAGS+=$(local_ldflags)"
$(call make-simple-bin,$(wildcard $(subdirectory)/*.cc),$(build_options))
## ==========================================

# ## ========== one build section ============
# local_src := hello1.cc
# local_bin := hello1
# # local_dynamiclib :=
# # local_staticlib :=
# local_cflags := #pass only to c compiler
# local_cxxflags := -lptherad #pass only to c++ compiler
# local_cppflags := #pass to both c & c++ compiler
# local_ldflags :=
# # ----- robot doing -----
# build_options := "CXXFLAGS+=$(local_cxxflags)"
# $(if $(local_bin),$(call make-bin,$(local_bin),$(subdirectory)/$(local_src),$(build_options)))
# $(if $(local_dynamiclib),$(call make-shared-library,$(local_dynamiclib),$(subdirectory)/$(local_src),$(build_options)))
# $(if $(local_staticlib),$(call make-shared-library,$(local_staticlib),$(subdirectory)/$(local_src),$(build_options)))
# ## ==========================================
