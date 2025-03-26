// swift-tools-version: 6.0

import PackageDescription

let wamrSource = "third-party/wasm-micro-runtime"

let macroDefinitions: [CSetting] = [
    "BH_MALLOC": "wasm_runtime_malloc",
    "BH_FREE": "wasm_runtime_free",
    //"WASM_ENABLE_AOT": "1",
    "WASM_ENABLE_BULK_MEMORY": "1",
    "WASM_ENABLE_FAST_INTERP": "1",
    "WASM_ENABLE_INTERP": "1",
    "WASM_ENABLE_LIBC_BUILTIN": "1",
    "WASM_ENABLE_LIB_PTHREAD": "1",
    "WASM_ENABLE_LIB_PTHREAD_SEMAPHORE": "1",
    "WASM_ENABLE_QUICK_AOT_ENTRY": "1",
    "WASM_ENABLE_SHARED_MEMORY": "1",
    "WASM_ENABLE_THREAD_MGR": "1",
    
    //"WASM_ENABLE_SIMD": "1",
    //"BUILD_TARGET": #""AARCH64""#,
    "WASM_ENABLE_MODULE_INST_CONTEXT": "1",
    "WASM_ENABLE_LIBC_WASI": "1",
    "WASM_ENABLE_LIB_WASI_THREADS": "1",
    
    "WASM_ENABLE_JIT": "1",
    "WASM_ENABLE_MEMORY64": "1",
    //"WASM_ENABLE_REF_TYPES": "1",
    //"WASM_ENABLE_STRINGREF": "1",
    //"WASM_ENABLE_GC": "1",
].map { .define($0.key, to: $0.value) } + [
    .define("BH_PLATFORM_DARWIN", to: "1", .when(platforms: [.macOS, .iOS, .tvOS, .watchOS])),
    .define("BH_PLATFORM_LINUX", to: "1", .when(platforms: [.linux])),
    .define("BH_PLATFORM_ANDROID", to: "1", .when(platforms: [.android])),
    .define("BH_PLATFORM_WINDOWS", to: "1", .when(platforms: [.windows])),
]

func wamrCorePlatforms(except: String) -> [String] {
    let platforms = ["riot", "vxworks", "linux-sgx", "alios", "linux", "android", "windows", "zephyr", "nuttx", "esp-idf", "darwin"]
    return platforms.filter { $0 != except }.map { "wamr/core/shared/platform/\($0.split(separator: "/").last!)" }
}

func invokeNative(_ platform: String) -> String {
    switch platform {
    case "darwin": return "invokeNative.s"
    case "linux": return "invokeNative.c"
    default: fatalError("unsupported platform \(platform)")
    }
}

func wamrCoreTarget(platform: String) -> Target {
    .target(
        name: "wamr-core-\(platform)",
        dependencies: [
        ],
        exclude: wamrCorePlatforms(except: platform) + [
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
            "wamr/core/iwasm/aot",
            /*
            "wamr/core/iwasm/aot/iwasm_aot.cmake",
            "wamr/core/iwasm/aot/SConscript",
            //"wamr/core/iwasm/aot/arch",
            "wamr/core/iwasm/aot/arch/aot_reloc_arc.c",
            "wamr/core/iwasm/aot/arch/aot_reloc_arm.c",
            "wamr/core/iwasm/aot/arch/aot_reloc_dummy.c",
            "wamr/core/iwasm/aot/arch/aot_reloc_mips.c",
            "wamr/core/iwasm/aot/arch/aot_reloc_riscv.c",
            "wamr/core/iwasm/aot/arch/aot_reloc_thumb.c",
            "wamr/core/iwasm/aot/arch/aot_reloc_x86_32.c",
            "wamr/core/iwasm/aot/arch/aot_reloc_x86_64.c",
            "wamr/core/iwasm/aot/arch/aot_reloc_xtensa.c",
            */
            "wamr/core/iwasm/aot/debug",
            "wamr/core/iwasm/common/SConscript",
            "wamr/core/iwasm/common/arch",
            "wamr/core/iwasm/common/iwasm_common.cmake",
            "wamr/core/iwasm/common/gc",
            //"wamr/core/iwasm/common/gc/iwasm_gc.cmake",
            //"wamr/core/iwasm/common/gc/gc_common.c",
            //"wamr/core/iwasm/common/gc/stringref",
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
            "wamr/core/shared/platform/\(platform)/shared_platform.cmake",
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
        ],
        sources: [
            "wamr/core/iwasm/aot",
            "wamr/core/iwasm/common",
            "wamr/core/iwasm/interpreter",
            "wamr/core/iwasm/libraries/lib-pthread",
            "wamr/core/iwasm/libraries/libc-builtin",
            "wamr/core/iwasm/libraries/libc-wasi",
            "wamr/core/iwasm/libraries/thread-mgr",
            "wamr/core/shared/mem-alloc",
            "wamr/core/shared/platform/\(platform)",
            "wamr/core/shared/platform/common/posix",
            "wamr/core/shared/utils",
            
            //"wamr/core/iwasm/common/arch/invokeNative_osx_universal.s",
            "wamr/core/shared/platform/common/libc-util",
            "wamr/core/shared/platform/common/memory",
            "wamr/core/iwasm/libraries/lib-wasi-threads",
            invokeNative(platform),
            //"wamr/core/shared/platform/alios",
        ],
        cSettings: macroDefinitions + [
            .headerSearchPath("wamr/core/iwasm/aot"),
            .headerSearchPath("wamr/core/iwasm/common"),
            .headerSearchPath("wamr/core/iwasm/include"),
            .headerSearchPath("wamr/core/iwasm/interpreter"),
            .headerSearchPath("wamr/core/iwasm/libraries/libc-builtin"),
            .headerSearchPath("wamr/core/iwasm/libraries/lib-pthread"),
            .headerSearchPath("wamr/core/iwasm/libraries/thread-mgr"),
            .headerSearchPath("wamr/core/shared/platform/\(platform)"),
            .headerSearchPath("wamr/core/shared/platform/include"),
            .headerSearchPath("wamr/core/shared/mem-alloc"),
            .headerSearchPath("wamr/core/shared/utils"),
            .headerSearchPath("wamr/core/shared/utils/uncommon"),
            
            .headerSearchPath("wamr/core/iwasm/libraries/lib-wasi-threads"),
            
            //.headerSearchPath("wamr/core/iwasm/common/memory"),
            //.headerSearchPath("wamr/core/iwasm/common/gc"),
            .headerSearchPath("wamr/core/iwasm/libraries/libc-wasi/sandboxed-system-primitives/include"),
            .headerSearchPath("wamr/core/iwasm/libraries/libc-wasi/sandboxed-system-primitives/src"),
            //.headerSearchPath("wamr/core/shared/platform/common"),
            .headerSearchPath("wamr/core/shared/platform/common/libc-util"),
        ]
    )
}

let wamrTargets: [Target] = [
    wamrCoreTarget(platform: "linux"),
    wamrCoreTarget(platform: "darwin"),
]
let wamrCoreDependencies: [Target.Dependency] = [
    .target(name: "wamr-core-linux", condition: .when(platforms: [.linux])),
    .target(name: "wamr-core-darwin", condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS])),
]

let package = Package(name: "wamr", products: [
    .library(name: "wamr", targets: ["wamr"])
], targets: wamrTargets + [
    .target(name: "wamr", dependencies: [.target(name: "wamr-core")]),
    .target(name: "wamr-core", dependencies: wamrCoreDependencies),
])
