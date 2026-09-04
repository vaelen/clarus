
#include "rt.h"
int main(void) {
    struct { uint8_t len; uint8_t b[255]; } msg = {6, {'h','i',13,'y','o','u'}}; /* embedded CR */
    rt_log((uint8_t*)&msg);
    return 0;
}
