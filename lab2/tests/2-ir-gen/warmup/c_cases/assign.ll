; ModuleID = 'assign.c'
source_filename = "assign.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [10 x i32], align 16
  store i32 0, ptr %1, align 4
  %3 = getelementptr inbounds [10 x i32], ptr %2, i64 0, i64 0
  store i32 10, ptr %3, align 16
  %4 = getelementptr inbounds [10 x i32], ptr %2, i64 0, i64 0
  %5 = load i32, ptr %4, align 16
  %6 = mul nsw i32 %5, 2
  %7 = getelementptr inbounds [10 x i32], ptr %2, i64 0, i64 1
  store i32 %6, ptr %7, align 4
  %8 = getelementptr inbounds [10 x i32], ptr %2, i64 0, i64 1
  %9 = load i32, ptr %8, align 4
  ret i32 %9
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
