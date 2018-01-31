#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>

double gettimeofday_sec() {
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return tv.tv_sec + tv.tv_usec * 1e-6;
}

int main () {
  FILE *fp;
  size_t ret;
  char buffer[512];
  double t1, t2;
  
  fp = fopen("./FileIOMeasuredApp/text.txt", "r");
  if ( fp == NULL ) {
    printf("can't open the file\n");
  }

  t1 = gettimeofday_sec();
  ret = fread(buffer, sizeof(char), 8, fp);
  if ( ret == 0 ) {
    printf("can't read the file\n");
    return 0;
  }
  t2 = gettimeofday_sec();
  printf("Time: %lf\n", t2-t1);
  
  printf("size is %lu\n", ret);
  printf("Readed: %s\n", buffer);
}
