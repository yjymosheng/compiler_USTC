define dso_local i32 @main() #0 {
    %1 = alloca i32 , align 4
    %2 = alloca [10 x i32] , align 4
    %ptr_0 = getelementptr [10 x i32] , [10 x i32] * %2 , i32 0 , i32 0
    store i32 10, i32 * %ptr_0
    %3 = load i32, i32* %ptr_0, align 4
    %4 = mul i32  %3 , 2
    %ptr_1 = getelementptr [10 x i32] , [10 x i32] * %2 , i32 0 , i32 1
    store i32 %4 , i32 * %ptr_1, align 4
    store i32 %4,i32 *  %1
    %5 = load i32 , i32 * %1
    ret i32 %5
}
