# CMINUSFC 编译器路径 (如果需要手动指定)
CMINUSFC ?= cminusfc


# 允许用户直接传入测试文件的完整路径，例如：
# make run testcases/lv1/idx_float.cminus
run:
	@if [ -z "$(filter-out run,$(MAKECMDGOALS))" ]; then \
		echo "Usage: make run <testcase>"; \
	else \
		$(CMINUSFC) $(filter-out run,$(MAKECMDGOALS)) -emit-llvm -o test.ll && \
		clang -O0 -w -no-pie test.ll -o test -lcminus_io && \
		./test; \
	fi


# 重新安装 cminusfc
install:
	@make install -C /workspace/build/

# 运行评测脚本
eval:
	@./eval_lab2.sh && cat eval_result | grep "total points: "

# 运行 GDB 调试 cminusfc
debug:
	@gdb /workspace/build/cminusfc

# 允许 `make` 识别额外的参数
.PHONY: run install eval debug
