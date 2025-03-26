import LibC

public func resolved(path: String) throws(Errno) -> String {
    func system_realpath(_ path: String) throws(Errno) -> String {
        guard let pointer = withUnsafeTemporaryAllocation(of: CChar.self, capacity: Int(PATH_MAX), {
            realpath(path, $0.baseAddress)
        }) else { throw Errno() }
        return String(cString: pointer)
    }
    
    let path = path.hasPrefix("~") ? (getHomeDirectory()! + path.dropFirst()) : path
    return try system_realpath(path)
}

public func temporary<T>(at directory: String, _ handler: () throws -> T) rethrows -> T {
    let previous: String?
    do {
        previous = try getCurrentDirectory()
    } catch {
        previous = nil
        print(error)
    }
    defer {
        if let previous {
            do {
                try setCurrentDirectory(previous)
            } catch {
                print(error)
            }
        }
    }
    do {
        let path = try resolved(path: directory)
        try setCurrentDirectory(path)
    } catch {
        print(error)
    }
    return try handler()
}
