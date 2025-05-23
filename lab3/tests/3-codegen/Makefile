# CMINUSFC 编译器路径 (如果需要手动指定)
CMINUSFC ?= cminusfc

mode ?= test
dir ?= testcases

# 参数解析
test:
	@if [ -z "$(dir)" ] || [ -z "$(mode)" ]; then \
		echo "[ERROR] Usage: make test dir=<test_dir> mode=<test_mode>"; \
		exit 1; \
	fi

	# 执行评测脚本
	@./eval_lab3.sh $(dir) $(mode)

# 重新安装 cminusfc
install:
	@make install -C /workspace/build/

## 运行评测脚本
#eval:
#	@./eval_lab2.sh && cat eval_result | grep "total points: "

clean:
	@./cleanup.sh


# 允许 `make` 识别额外的参数
.PHONY:  install test
