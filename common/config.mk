include ../config.sh

USER := $(shell echo $(USER))
PASSWORD := $(shell echo $(PASSWORD))
SSH_PARAMS := $(shell echo $(SSH_PARAMS))
IP := $(shell echo $(IP))
PORT := $(shell echo $(PORT))
ENDPOINT := $(USER)@$(IP)

