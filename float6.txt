#include <stdio.h>

double printResult(double x, int k, double r) {
    double b = 1;
    double a = 1;
    double last;
    while (r - last >= r * 0.0005) {
        last = r;
        k = k + 2;
        b = b * k * (k + 1);
        a = a * x * x;
        r = r + a / b;
    }
    return r;
}
int main() {
    double x;
    scanf("%lf", &x);
    double r = 1;
    int k = -1;
    r = printResult(x, k, r);
    printf("%f", r);
}