// swift-tools-version: 6.0

import PackageDescription

let config: [CSetting] = [
    "WASM_ENABLE_SHARED_MEMORY",
    "WASM_ENABLE_BULK_MEMORY",
    "WASM_ENABLE_MEMORY64",
    
    "WASM_ENABLE_INTERP",
    "WASM_ENABLE_FAST_INTERP",
    "WASM_ENABLE_TAIL_CALL",
    "WASM_ENABLE_REF_TYPES",
    "WASM_ENABLE_JIT",
    
    "WASM_ENABLE_LIBC_BUILTIN",
    "WASM_ENABLE_LIB_PTHREAD",
    "WASM_ENABLE_LIB_PTHREAD_SEMAPHORE",
    "WASM_ENABLE_QUICK_AOT_ENTRY",
    "WASM_ENABLE_THREAD_MGR",
    
    "WASM_ENABLE_MODULE_INST_CONTEXT",
    "WASM_ENABLE_LIBC_WASI",
    "WASM_ENABLE_LIB_WASI_THREADS",
    
    "WASM_ENABLE_CUSTOM_NAME_SECTION",
    "WASM_ENABLE_DUMP_CALL_STACK",
    "WASM_ENABLE_PERF_PROFILING",
    "WASM_ENABLE_MEMORY_PROFILING",
    "WASM_ENABLE_LOAD_CUSTOM_SECTION",
    
    "WASM_ENABLE_GC",
    "WASM_ENABLE_STRINGREF",
    "WASM_ENABLE_MULTI_MODULE",
].map({ .define($0, to: "1") })

let macroDefinitions: [CSetting] = [
    "BH_MALLOC": "wasm_runtime_malloc",
    "BH_FREE": "wasm_runtime_free",
].map({ .define($0.key, to: $0.value) })

let headerSearchPaths: [CSetting] = [
    "wamr/core/iwasm/common",
    "wamr/core/iwasm/common/gc",
    "wamr/core/iwasm/common/gc/stringref",
    "wamr/core/iwasm/include",
    "wamr/core/iwasm/interpreter",
    "wamr/core/iwasm/libraries/libc-builtin",
    "wamr/core/iwasm/libraries/lib-pthread",
    "wamr/core/iwasm/libraries/thread-mgr",
    "wamr/core/shared/platform/common/libc-util",
    "wamr/core/shared/platform/include",
    "wamr/core/shared/mem-alloc",
    "wamr/core/shared/utils",
    "wamr/core/shared/utils/uncommon",
    "wamr/core/iwasm/libraries/libc-wasi/sandboxed-system-primitives/include",
    "wamr/core/iwasm/libraries/libc-wasi/sandboxed-system-primitives/src",
].map({ .headerSearchPath($0) })

let debug: [CSetting] = [.define("BH_DEBUG", to: "1", .when(configuration: .debug))]
let settings: [CSetting] = config + macroDefinitions + headerSearchPaths + debug

let exclude: [String] = [
    "wamr/ATTRIBUTIONS.md",
    "wamr/CODE_OF_CONDUCT.md",
    "wamr/CONTRIBUTING.md",
    //"wamr/Dockerfile",
    "wamr/LICENSE",
    "wamr/ORG_CODE_OF_CONDUCT.md",
    "wamr/README.md",
    "wamr/SConscript",
    "wamr/SECURITY.md",
    //"wamr/assembly-script",
    "wamr/build-scripts",
    "wamr/build-scripts/SConscript",
    //"wamr/core/app-framework",
    //"wamr/core/app-mgr",
    "wamr/core/deps",
    "wamr/core/iwasm/README.md",
    //"wamr/core/iwasm/aot",
    "wamr/core/iwasm/aot/iwasm_aot.cmake",
    "wamr/core/iwasm/aot/SConscript",
    //"wamr/core/iwasm/aot/arch",
    
    "wamr/core/iwasm/aot/arch/aot_reloc_arc.c",
    "wamr/core/iwasm/aot/arch/aot_reloc_dummy.c",
    "wamr/core/iwasm/aot/arch/aot_reloc_mips.c",
    "wamr/core/iwasm/aot/arch/aot_reloc_riscv.c",
    "wamr/core/iwasm/aot/arch/aot_reloc_thumb.c",
    "wamr/core/iwasm/aot/arch/aot_reloc_xtensa.c",
    
    "wamr/core/iwasm/aot/debug",
    "wamr/core/iwasm/common/SConscript",
    "wamr/core/iwasm/common/arch",
    "wamr/core/iwasm/common/iwasm_common.cmake",
    //"wamr/core/iwasm/common/gc",
    "wamr/core/iwasm/common/gc/iwasm_gc.cmake",
    "wamr/core/iwasm/compilation",
    "wamr/core/iwasm/interpreter/SConscript",
    "wamr/core/iwasm/interpreter/iwasm_interp.cmake",
    "wamr/core/iwasm/interpreter/wasm_interp_classic.c",
    "wamr/core/iwasm/interpreter/wasm_mini_loader.c",
    //"wamr/core/iwasm/libraries/lib-pthread",
    "wamr/core/iwasm/libraries/lib-pthread/SConscript",
    "wamr/core/iwasm/libraries/lib-pthread/lib_pthread.cmake",
    "wamr/core/iwasm/libraries/libc-builtin/SConscript",
    "wamr/core/iwasm/libraries/libc-builtin/libc_builtin.cmake",
    "wamr/core/iwasm/libraries/libc-emcc",
    "wamr/core/iwasm/libraries/libc-emcc/SConscript",
    //"wamr/core/iwasm/libraries/libc-wasi",
    "wamr/core/iwasm/libraries/libc-wasi/SConscript",
    "wamr/core/iwasm/libraries/libc-wasi/libc_wasi.cmake",
    "wamr/core/iwasm/libraries/libc-wasi/sandboxed-system-primitives/LICENSE",
    "wamr/core/iwasm/libraries/libc-wasi/sandboxed-system-primitives/include/LICENSE",
    "wamr/core/iwasm/libraries/libc-wasi/sandboxed-system-primitives/src/LICENSE",
    "wamr/core/iwasm/libraries/libc-wasi/sandboxed-system-primitives/src/README.md",
    "wamr/core/iwasm/libraries/lib-wasi-threads/test",
    "wamr/core/iwasm/libraries/lib-wasi-threads/stress-test",
    "wamr/core/iwasm/libraries/lib-wasi-threads/unit-test",
    "wamr/core/iwasm/libraries/lib-wasi-threads/SConscript",
    "wamr/core/iwasm/libraries/lib-wasi-threads/lib_wasi_threads.cmake",
    //"wamr/core/iwasm/libraries/thread-mgr",
    "wamr/core/iwasm/libraries/thread-mgr/SConscript",
    "wamr/core/iwasm/libraries/thread-mgr/thread_mgr.cmake",
    "wamr/core/shared/coap",
    "wamr/core/shared/mem-alloc/SConscript",
    "wamr/core/shared/mem-alloc/mem_alloc.cmake",
    "wamr/core/shared/platform/README.md",
    "wamr/core/shared/platform/common/freertos",
    "wamr/core/shared/platform/common/math",
    "wamr/core/shared/platform/common/memory/platform_api_memory.cmake",
    "wamr/core/shared/platform/common/libc-util/SConscript",
    "wamr/core/shared/platform/common/libc-util/platform_common_libc_util.cmake",
    //"wamr/core/shared/platform/common/posix",
    "wamr/core/shared/platform/common/posix/platform_api_posix.cmake",
    "wamr/core/shared/platform/common/posix/SConscript",
    "wamr/core/shared/platform/include",
    "wamr/core/shared/platform/rt-thread/SConscript",
    "wamr/core/shared/utils/SConscript",
    "wamr/core/shared/utils/shared_utils.cmake",
    "wamr/core/shared/utils/uncommon/SConscript",
    "wamr/core/shared/utils/uncommon/shared_uncommon.cmake",
    "wamr/doc",
    "wamr/product-mini",
    "wamr/product-mini/platforms/rt-thread/SConscript",
    "wamr/samples",
    "wamr/test-tools",
    "wamr/wamr-compiler",
    "wamr/wamr-sdk",
]

var sources: [String] = [
    "wamr/core/iwasm/common",
    "wamr/core/iwasm/common/gc",
    "wamr/core/iwasm/common/gc/stringref",
    "wamr/core/iwasm/interpreter",
    "wamr/core/iwasm/libraries/lib-pthread",
    "wamr/core/iwasm/libraries/libc-builtin",
    "wamr/core/iwasm/libraries/libc-wasi",
    "wamr/core/iwasm/libraries/thread-mgr",
    "wamr/core/shared/mem-alloc",
    "wamr/core/shared/utils",
    
    "wamr/core/shared/platform/common/libc-util",
    "wamr/core/iwasm/libraries/lib-wasi-threads",
]

#if ANDROID
let target: Target = .target(name: "wamr", exclude: exclude + [
    "wamr/core/shared/platform/android/shared_platform.cmake",
], sources: sources + [
    "wamr/core/shared/platform/common/posix",
    "wamr/core/shared/platform/android",
    "invokeNative.c",
], cSettings: settings + [
    .define("WASM_HAVE_MREMAP", to: "1"),
    .define("BH_PLATFORM_ANDROID", to: "1"),
    .headerSearchPath("wamr/core/shared/platform/common/posix"),
    .headerSearchPath("wamr/core/shared/platform/android"),
])
#elseif LINUX
let target: Target = .target(name: "wamr", exclude: exclude + [
    "wamr/core/shared/platform/linux/shared_platform.cmake",
], sources: sources + [
    "wamr/core/shared/platform/common/posix",
    "wamr/core/shared/platform/common/memory",
    "wamr/core/shared/platform/linux",
    "invokeNative.c",
], cSettings: settings + [
    //.define("WASM_HAVE_MREMAP", to: "1"),
    .define("BH_PLATFORM_LINUX", to: "1"),
    .headerSearchPath("wamr/core/shared/platform/common/posix"),
    .headerSearchPath("wamr/core/shared/platform/linux"),
])
#elseif WINDOWS
let target: Target = .target(name: "wamr", exclude: exclude + [
    "wamr/core/shared/platform/common/memory",
    "wamr/core/shared/platform/windows/shared_platform.cmake",
], sources: sources + [
    "wamr/core/shared/platform/windows",
    "invokeNative.c",
], cSettings: settings + [
    .define("BH_PLATFORM_WINDOWS", to: "1"),
    .headerSearchPath("wamr/core/shared/platform/windows"),
])
#else //APPLE
let target: Target = .target(name: "wamr", exclude: exclude + [
    "wamr/core/shared/platform/darwin/shared_platform.cmake",
], sources: sources + [
    "wamr/core/shared/platform/common/posix",
    "wamr/core/shared/platform/common/memory",
    "wamr/core/shared/platform/darwin",
    "invokeNative.s",
], cSettings: settings + [
    .define("BH_PLATFORM_DARWIN", to: "1"),
    .headerSearchPath("wamr/core/shared/platform/common/posix"),
    .headerSearchPath("wamr/core/shared/platform/darwin"),
])
#endif

let package = Package(name: "wamr", products: [
    .library(name: "wamr", targets: ["wamr"]),
], targets: [target])
