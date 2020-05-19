#include <hxcpp.h>

#include <hx/Tls.h>

#if HX_PSVITA

SceUID tlsSlotLock = sceKernelCreateMutex("tlsIndexLock", SCE_KERNEL_MUTEX_ATTR_RECURSIVE, 0, nullptr);
int tlsSlotIndex = 0;

#endif