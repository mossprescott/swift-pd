#define TARGET_EXTENSION 1
#include "pd_api.h"

// // Call a C vararg function via a pointer, passing no additional arguments. Easier to do it here
// // than figure out how to explain it to Swift.
// void invokePrintf(void *f(const char*, ...), const char *str) {
//     f(str);
// }

// Wrap calls to C vararg functions passing no additional arguments. Easier to do it here
// than figure out how to explain it to Swift.

void _logToConsole0(PlaydateAPI *playdate, const char *str) {
    playdate->system->logToConsole(str);
}

void _error0(PlaydateAPI *playdate, const char *str) {
    playdate->system->error(str);
}