@_cdecl("eventHandler")
public func eventHandler(_ playdate: PlaydateAPI, _ event: PDSystemEvent, _ arg: Int32) -> Int32 {
    if event == kEventInit {
        Playdate.playdate = playdate

        setup()

        playdate.system.pointee.setUpdateCallback(updateCallback, nil)
    }
    return 0
}

private func updateCallback(_: UnsafeMutableRawPointer?) -> Int32 {
    return update() ? 1 : 0
}

enum Color: UInt {
    case black
    case white
    case clear
    case xor
    // case pattern(<pointer to 16 bytes containing pixels>)
}

/// Just a namespace for Playdate API wrappers to live in.
enum Playdate {
    fileprivate static var playdate: PlaydateAPI!

    enum System {
        static func drawFPS(x: Int, y: Int) {
            playdate.system.pointee.drawFPS(Int32(x), Int32(y))
        }
    }

    enum Graphics {
        static func clear(_ color: Color) {
            playdate.graphics.pointee.clear(color.rawValue)
        }

        @discardableResult
        static func drawText(_ message: String, x: Int, y: Int) -> Int {
            return Int(playdate.graphics.pointee.drawText(message, message.count, kUTF8Encoding,
                        Int32(x), Int32(y)))
        }
    }
}
