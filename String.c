#include <stdio.h>
char str[128] = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

int count_chars(char a[]){
    int n=0;
	for (int i = 0; i<9; i++){
		for(int c =0; c<97; c++ ){
		    if(a[i]==str[c])
		    {
		        n+=1;
		        break;
		    }
		}
	}
	return n;
}
int main() {
    char inputString[9];
    for (int c = 0; c < 9; c++) {
        scanf("%c", &inputString[c]);
    }
    int n = count_chars(inputString);
    printf("%d", n);
    return 0;
}



