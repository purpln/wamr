import LibC
import wamr

let directory = "~/github/wamr"

try temporary(at: directory, {
    let binary = try read(path: "app.wasm")
    WasmRuntime.initialize()
    let module = try WasmModule(binary: binary)
    module.setWasiOptions(dirs: [], mapDirs: [], envs: [], args: [])
    let instance = try module.instantiate(stackSize: 64 * 1024)
    try instance.executeMain(args: [])
})
