#include <stdio.h>
#include <stdlib.h>


char board [12];


int min();
int bestMove();
int cantMovePebble();
void moveLeft();
void moveRight();


int main() {
  while( scanf( "%s", board ) == 1) {
    int pebble = 0;
    for (int i=0; i<12; i++) if (board[i] == 'o') pebble++;
    if (pebble != 0) printf("%d\n", bestMove(pebble));
  }
  return 0;
}

int min(int a, int b) {
  if (a < b) return a;
  else return b;
}

int cantMovePebble() {
  for (int i=0 ; i<11 ; i++)
    if (board[i] == 'o' && board[i+1] == 'o') return 1;
  return 0;
}

void moveLeft(int *left, int pebble, int i) {
  board[i-1] = 'o';
  board[i] = '-';
  board[i+1] = '-';
  *left = bestMove(pebble-1);
  board[i-1] = '-';
  board[i] = 'o';
  board[i+1] = 'o';
}

void moveRight(int *right, int pebble, int i) {
  board[i+2] = 'o';
  board[i+1] = '-';
  board[i] = '-';
  *right = bestMove(pebble-1);
  board[i+2] = '-';
  board[i+1] = 'o';
  board[i] = 'o';
}


int bestMove(int pebble) {
  if (!cantMovePebble()) return pebble;
  else {
    int cnt, left, right;
    cnt = pebble;
    left = right = pebble;
    for (int i=0 ; i<11 ; i++) {
      if (board[i] == 'o' && board[i+1] == 'o') {
	if (i-1 >= 0 && board[i-1] == '-') moveLeft(&left, pebble, i); 
	if (i+2 < 12 && board[i+2] == '-') moveRight(&right, pebble, i);
	cnt = min(cnt, min(left, right));
      }
    }
    return cnt;
  } 
}

