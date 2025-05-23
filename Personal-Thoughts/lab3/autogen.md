修改了 [eval_lab3.sh](../../lab3/tests/3-codegen/eval_lab3.sh) 的测试路径

由于采用docker 目录，测试目录应当有所修改

```markdown
- project_dir=$(realpath ../../../)
+ project_dir=$(realpath ../../../)
```

