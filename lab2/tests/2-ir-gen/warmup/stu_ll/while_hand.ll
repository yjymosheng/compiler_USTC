define dso_local i32 @main() #0 {
    %1 = alloca i32
    %a = alloca i32
    %i = alloca i32

    store i32 10 ,i32 *  %a
    store i32 0 , i3 *  %i
    br label %2

2:
    %3  = load i32 , i32 * %i
    %4 = icmp  slt i32 %3 ,10
    br i1 %4 ,label %5 ,label %10

5:
    %6  = load i32 , i32 * %i
    %7 = add i32  %6 ,1
    store i32 %7 , i32* %i
    %8  = load i32 , i32 * %a
    %9 = add i32  %8 , %7
    store i32 %9 , i32* %a
    br label %2

10:
    %11 = load i32 , i32* %a
    ret i32 %11
}
