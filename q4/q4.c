#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main() {
    char line[100];

    while (fgets(line,sizeof(line),stdin)) {
        char op[6];
        int a,b;

        sscanf(line,"%s %d %d",op,&a,&b); //read thru line
        char libname[64]; //library name
        snprintf(libname,sizeof(libname),"./lib%s.so",op);

        void *handle = dlopen(libname,RTLD_LAZY);// open the library
        if (!handle) continue;
        dlerror(); // clear prev errors

        int (*func)(int,int) = (int (*)(int,int)) dlsym(handle,op); //fxn ptr.
        int result = func(a,b);
        printf("%d\n",result);
        dlclose(handle);
    }

    return 0;
}