import CPlaydate

/// Warning: these have to mirror the values in the C type
public enum Color: UInt {
    case black
    case white
    case clear
    case xor
    // case pattern(<pointer to 16 bytes containing pixels>)
}

public class Font {
    var c_font: OpaquePointer?

    init(_ font: OpaquePointer?) {
        self.c_font = font
    }

    // TODO: Do Fonts need to be freed? it's unclear from the docs
    // deinit {

    // }
}

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

    public enum Graphics {
        public static func clear(_ color: Color) {
            c_api.graphics.pointee.clear(color.rawValue)
        }

        public static func drawText(_ message: String, x: Int, y: Int) {
            let _ = c_api.graphics.pointee.drawText(message, message.count, kUTF8Encoding,
                        Int32(x), Int32(y))
        }

        public static func loadFont(_ path: String) throws -> Font {
            // var err: UnsafeMutablePointer<UnsafePointer<CChar>?> = UnsafeMutablePointer(0)
            var err: UnsafePointer<CChar>? = nil
            let ptr = c_api.graphics.pointee.loadFont(path, &err)
            if let err = err {
                throw RuntimeError.FontNotLoaded(String(cString: err))
            }
            else {
                return Font(ptr)
            }
        }

        public static func setFont(_ font: Font) {
            c_api.graphics.pointee.setFont(font.c_font)
        }
    }
}
