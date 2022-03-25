#define TARGET_EXTENSION 1
#include "pd_api.h"


// Wrap calls to C vararg functions passing no additional arguments. Easier to do it here
// than figure out how to explain it to Swift.

void _logToConsole0(PlaydateAPI *playdate, const char *str) {
    playdate->system->logToConsole(str);
}

void _error0(PlaydateAPI *playdate, const char *str) {
    playdate->system->error(str);
}