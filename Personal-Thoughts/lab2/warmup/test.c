int x[10];
int y[10];

int main(){
    int i=0 ;
    int sum=0;
    while (i<10){
        x[i] = 2*i;
        y[i] = 1*i;
        sum = x[i] + y[i] + sum;
    }
    return sum ;
}