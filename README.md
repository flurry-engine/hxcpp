# hxcpp

[![Build Status](https://dev.azure.com/HaxeFoundation/GitHubPublic/_apis/build/status/HaxeFoundation.hxcpp?branchName=master)](https://dev.azure.com/HaxeFoundation/GitHubPublic/_build/latest?definitionId=3&branchName=master)

hxcpp is the runtime support for the c++ backend of the [haxe](http://haxe.org/) compiler. This contains the headers, libraries and support code required to generate a fully compiled executable from haxe code.

# PSVita Changes

This branch contains a toolchain for compiling to Sony's PlayStation Vita console using the open source vitaSDK. To use ensure you [install vitasdk](https://vitasdk.org/) and add `-D psvita` to your hxml file, after compiling you should have a .elf file in the output directory.

```haxe
# example hxml file
-cp src
-D analyzer-optimize
-D psvita
-main Main
--cpp bin
```

The toolchain does not currently go through the process of creating the .velf, .eboot, and the final .vpk, but could in the future.

VitaSDK provides a posix environment and a pthreads library so most things work out of the box, but some changes were needed. PSVita programs are sandboxed so the Process.cpp stubs used for WinRT are used. The vitasdk does not seem to provide `poll.h` which is used in Socket.cpp for unix systems, sockets will not work at the moment due to this.

Non Windows platforms have `HX_GC_PTHREADS` defined which causes the GC to manually create a pthread condition instead of going through the HxSemaphore struct. For some reason this causes the GC to crash when adding a root for the `String` boot function, so this define is not set for the vita. I'm not sure if this is a HXCPP issue or something wrong with the pthread library provided by vitasdk.

Changes were made to `StdLibs.cpp` so `Sys.systemName` returns "PSVita". `Sys.sleep` had to be changed to use `sceKernelDelayThread` as `nanosleep` is not available. `Sys.time` / `Timer.stamp` also now use Sony APIs as well.

I'm planning on adding support for vita specific api's in areas such as file i/o, sockets, and threading instead of relying on the posix ones.

A small example program and some initial api externs can be found at https://github.com/aidan63/hx_vitasdk

# building the tools

```
REPO=$(pwd)
cd ${REPO}/tools/run
haxe compile.hxml
cd ${REPO}/tools/hxcpp
haxe compile.hxml
cd $REPO
```

# cppia

You first need to build the cppia host.

```
REPO=$(pwd)
cd ${REPO}/project
haxe compile-cppia.hxml
cd $REPO
```

Then you can do `haxelib run hxcpp file.cppia`.
