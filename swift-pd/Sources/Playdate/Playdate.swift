import CPlaydate

public enum RuntimeError: Error {
    case msg(String)
}

/// Just a namespace to hold onto the single global reference to the C API struct.
enum Playdate {
    static var c_api: PlaydateAPI!
}

func checkError(_ err: UnsafePointer<CChar>?) throws {
    if let err = err {
        throw RuntimeError.msg(String(cString: err))
    }
}