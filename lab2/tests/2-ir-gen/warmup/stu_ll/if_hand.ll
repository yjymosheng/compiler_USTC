define dso_local i32 @main() #0 {
    %1 = alloca float
    %2 = alloca i32
    store float 0x40163851E0000000 , float* %1
    %3 = sitofp i32 1 to float
    %4 = load float ,float * %1
    %5 = fcmp ugt float %4 , %3
    br i1 %5 ,label %6 ,label %7

6:
    store i32 233 ,i32 * %2
    br label %8

7:
    store i32 0 ,i32 * %2
    br label %8

8:
    %9 = load i32 , i32 * %2
    ret i32 %9
}
