import CPlaydate

/// Just a namespace to hold onto the single global reference to the C API struct.
enum Playdate {
    static var c_api: PlaydateAPI!
}

public enum RuntimeError: Error {
    case msg(String)
    case allocNull
}

/// If an error message is produced, or the ptr is nil, throw a RuntimeError.
func checkResult(_ ptr: OpaquePointer?, _ err: UnsafePointer<CChar>?) throws -> OpaquePointer {
    if let err = err {
        throw RuntimeError.msg(String(cString: err))
    }
    else if let nonNilPtr = ptr {
        return nonNilPtr
    }
    else {
        throw RuntimeError.allocNull
    }
}
func checkError(_ err: UnsafePointer<CChar>?) throws {
    if let err = err {
        throw RuntimeError.msg(String(cString: err))
    }
}