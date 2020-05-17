
include ../common/config.mk


NAME = $(shell basename $(shell pwd))
DIR = /home/$(USER)/$(NAME)
BUILD = build
TARGET = $(BUILD)/$(NAME)
C_SRCS = $(shell find -name *.c)
CPP_SRCS = $(shell find -name *.cpp)
C_OBJS = $(C_SRCS:./%.c=./$(BUILD)/%.c_o)
CPP_OBJS = $(CPP_SRCS:./%.cpp=./$(BUILD)/%.cpp_o)

CC = arm-linux-gnueabi-gcc
CXX = arm-linux-gnueabi-g++
DEFAULT_CFLAGS = -g3 -O0

all: run

parameters:
	@echo
	@echo "================================================================================================="
	@echo "Parameters"
	@echo "================================================================================================="
	@echo "USER =           $(USER)"
	@echo "PASSWORD =       $(PASSWORD)"
	@echo "IP =             $(IP)"
	@echo "PORT =           $(PORT)"
	@echo "SSH_PARAMS =     $(SSH_PARAMS)"
	@echo "ENDPOINT =       $(ENDPOINT)"
	@echo "NAME =           $(NAME)"
	@echo "DIR =            $(DIR)"
	@echo "BUILD =          $(BUILD)"
	@echo "TARGET =         $(TARGET)"
	@echo "CC =             $(CC)"
	@echo "CXX =            $(CXX)"
	@echo "CFLAGS =         $(CFLAGS)"
	@echo "LFLAGS =         $(LFLAGS)"
	@echo "DEFAULT_CFLAGS = $(DEFAULT_CFLAGS)"
	@echo "C_SRCS =         $(C_SRCS)"
	@echo "CPP_SRCS =       $(CPP_SRCS)"
	@echo "C_OBJS =         $(C_OBJS)"
	@echo "CPP_OBJS =       $(CPP_OBJS)"
	@echo "================================================================================================="
	@echo

pre_compile: parameters
	@echo
	@echo "================================================================================================="
	@echo "Compiling $(NAME) ..."
	@echo "================================================================================================="
	@echo

post_compile:
	@echo "Compiling done!"
	@echo

compile: pre_compile $(BUILD) $(TARGET) post_compile
	
$(TARGET): $(C_OBJS) $(CPP_OBJS)
	$(CXX) -o $@ $^ $(LFLAGS)

$(BUILD)/%.c_o: %.c
	$(CC) -c $< -o $@ $(CFLAGS) $(DEFAULT_CFLAGS)

$(BUILD)/%.cpp_o: %.cpp
	$(CXX) -c $< -o $@ $(CFLAGS) $(DEFAULT_CFLAGS)

$(BUILD):
	mkdir -p $(BUILD)

pre_prepare:
	@echo
	@echo "================================================================================================="
	@echo "Preparing $(NAME) on the target ..."
	@echo "================================================================================================="
	@echo

post_prepare:
	@echo
	@echo Preparing done!
	@echo

target_prepare:
# Preparation for copying
	@echo "Removing $(NAME) directory from target."
	@sshpass -p $(PASSWORD) ssh -p $(PORT) $(SSH_PARAMS) $(ENDPOINT) "[ -d $(DIR) ] && rm -Rf $(DIR) || true"
	@echo "Creating empty $(NAME) directory."
	@sshpass -p $(PASSWORD) ssh -p $(PORT) $(SSH_PARAMS) $(ENDPOINT) "mkdir -p $(DIR)"
# Copying
	@echo "Copying executable."
	@sshpass -p $(PASSWORD) scp -P $(PORT) $(SSH_PARAMS) $(TARGET)   $(ENDPOINT):$(DIR)

prepare: compile pre_prepare target_prepare post_prepare

pre_run:
	@echo
	@echo "================================================================================================="
	@echo "Running $(NAME) ..."
	@echo "================================================================================================="
	@echo

run: prepare pre_run
	@sshpass -p "$(PASSWORD)" ssh -p $(PORT) $(SSH_PARAMS) $(ENDPOINT) "cd $(DIR) && ./$(NAME) 2>&1"
	@echo

pre_clean:
	@echo
	@echo "================================================================================================="
	@echo "Cleaning $(NAME) on the target ..."
	@echo "================================================================================================="
	@echo

post_clean:
	@echo Cleaning done!
	@echo

target_clean:
	@rm -Rf build
	@sshpass -p "$(PASSWORD)" ssh -p $(PORT) $(SSH_PARAMS) $(ENDPOINT) "[ -d $(DIR) ] && rm -Rf $(DIR) || true"

clean: pre_clean target_clean post_clean

.PHONY: pre_compile post_compile compile pre_prepare target_prepare post_prepare pre_run run pre_clean post_clean target_clean clean
.DEFAULT: run
