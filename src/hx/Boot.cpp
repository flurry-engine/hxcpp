#include <hxcpp.h>
#include <hxMath.h>
#include <psp2/kernel/clib.h>

#ifdef HX_WINRT
#include<Roapi.h>
#endif

namespace hx
{
	void Boot()
	{
		sceClibPrintf("Booting\r\n");

		//__hxcpp_enable(false);
		#ifdef HX_WINRT
		HRESULT hr = ::RoInitialize(  RO_INIT_MULTITHREADED );
		#endif

		#ifdef GPH
		setvbuf( stdout , 0 , _IONBF , 0 );
		setvbuf( stderr , 0 , _IONBF , 0 );
		#endif

		__hxcpp_stdlibs_boot();

		sceClibPrintf("object\r\n");
		Object::__boot();

		sceClibPrintf("dynamic\r\n");
		Dynamic::__boot();

		sceClibPrintf("class\r\n");
		hx::Class_obj::__boot();

		sceClibPrintf("string\r\n");
		String::__boot();

		sceClibPrintf("anon\r\n");
		Anon_obj::__boot();

		sceClibPrintf("array\r\n");
		ArrayBase::__boot();

		sceClibPrintf("enum\r\n");
		EnumBase_obj::__boot();

		sceClibPrintf("math\r\n");
		Math_obj::__boot();
	}
}