import CPlaydate

enum RuntimeError: Error {
    case FontNotLoaded(String)
}

/// Just a namespace for Playdate API wrappers to live in.
public enum Playdate {
    static var c_api: PlaydateAPI!

    public enum System {
        /// See https://sdk.play.date/1.9.3/Inside%20Playdate%20with%20C.html#f-system.error
        ///
        /// Limitations: `message` should contain only ASCII characters, with no formatting.
        /// Use Swift string interpolation to construct strings.
        public static func error(_ message: String) {
            _error0(withUnsafeMutablePointer(to: &c_api) { $0 }, message)
        }

        /// See https://sdk.play.date/1.9.3/Inside%20Playdate%20with%20C.html#f-system.logToConsole
        ///
        /// Limitations: `message` should contain only ASCII characters, with no formatting.
        /// Use Swift string interpolation to construct strings.
        public static func logToConsole(_ message: String) {
            // invokePrintf(c_api.system.pointee.logToConsole, message)
            _logToConsole0(withUnsafeMutablePointer(to: &c_api) { $0 }, message)
        }

        public static func drawFPS(x: Int, y: Int) {
            c_api.system.pointee.drawFPS(Int32(x), Int32(y))
        }
    }
}

func checkError(_ err: UnsafePointer<CChar>?) throws {
    if let err = err {
        throw RuntimeError.FontNotLoaded(String(cString: err))
    }
}