#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>

double gettimeofday_sec() {
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return tv.tv_sec + tv.tv_usec * 1e-6;
}

int main () {
  size_t fp;
  size_t ret;
  char buffer[1024];
  double t1, t2, t3;
  
  t1 = gettimeofday_sec();
  fp = (size_t)fopen("./text.txt", "r");
  // if ( fp == NULL ) {
  //   printf("can't open the file\n");
  // }
  t2 = gettimeofday_sec();

  ret = fread(buffer, sizeof(char), 1024, (FILE*)fp);
  // if ( ret == 0 ) {
  //   printf("can't read the file\n");
  //   return 0;
  // }
  t3 = gettimeofday_sec();
  printf("fopen() Time: %lf\n", t2-t1);
  printf("fread() Time: %lf\n", t3-t2);
  printf("Total Time  : %lf\n", t3-t1);
  
  printf("size is %lu\n", ret);
  printf("Readed: %s\n", buffer);
}
