#include <stdio.h>
#include <string.h>

int countSpace(char str[], int len) {
  int counter = 0;
  for (int i=0; i < len; i++) {
    if (str[i] == '_') counter++;
  }
  return counter;
}

int countLower(char str[], int len) {
  int counter = 0;
  for (int i; i < len; i++) {
    if (str[i] >= 'a'  && str[i] <= 'z') counter++;
  }
  return counter;
}

int countUpper(char str[], int len) {
  int counter = 0;
  for (int i; i < len; i++) {
    if (str[i] >= 'A'  && str[i] <= 'Z') counter++;
  }
  return counter;
}

int countSymbol(char str[], double len) {
  double counter = 0;
  for (int i; i < len; i++) {
    if ((str[i] >= 33  && str[i] <= 64) \
	|| (str[i] >= 91  && str[i] != 95 && str[i] <= 96 )\
	|| (str[i] >= 123 && str[i] <= 126))				    \
      counter++;
  }
  return counter;
}


int main() {
  char input [1000000];
  int len;
  int space, lower, upper, symbol;
  while( scanf( "%s", input ) == 1) {
  len = strlen(input);
      space = countSpace(input, len);
      lower = countLower(input, len);
      upper = countUpper(input, len);
      symbol = countSymbol(input, len);
      printf("%f\n", space/((double)len));
      printf("%f\n", lower/((double)len));
      printf("%f\n", upper/((double)len));
      printf("%f\n", symbol/((double)len));
  }
  return 0;
}
