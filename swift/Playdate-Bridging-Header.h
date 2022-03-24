#define TARGET_EXTENSION 1
#include <pd_api.h>

// Call a C vararg function via a pointer, passing no additional arguments. Easier to do it here
// than figure out how to explain it to Swift.
void invokePrintf(void *f(const char*, ...), const char *str) {
    f(str);
}