import CPlaydate

/// Warning: these have to mirror the values in the C type
public enum Color: UInt {
    case black
    case white
    case clear
    case xor
    // case pattern(<pointer to 16 bytes containing pixels>)
}

/// Warning: these have to mirror the values in the C type
public enum Flip: UInt32 {
    case unflipped
    case flippedX
    case flippedY
    case flippedXY
}

public enum Graphics {
    private static var c_gfx: playdate_graphics {
        Playdate.c_api.graphics.pointee
    }

    public class Bitmap {
        let c_bitmap: OpaquePointer?

        public init(x: Int, y: Int, bgColor: Color) {
            c_bitmap = c_gfx.newBitmap(Int32(x), Int32(y), bgColor.rawValue)
        }

        public init(path: String) throws {
            var err: UnsafePointer<CChar>? = nil
            c_bitmap = c_gfx.loadBitmap(path, &err)
        }

        public var width: Int {
            var value: Int32 = 0
            c_gfx.getBitmapData(c_bitmap, &value, nil, nil, nil, nil)
            return Int(value)
        }

        public var height: Int {
            var value: Int32 = 0
            c_gfx.getBitmapData(c_bitmap, nil, &value, nil, nil, nil)
            return Int(value)
        }

        // TODO: rowBytes, hasMask, data, or expose the bits some other way

        public func draw(x: Int, y: Int, flip: Flip = .unflipped) {
            c_gfx.drawBitmap(c_bitmap, Int32(x), Int32(y), LCDBitmapFlip(flip.rawValue))
        }

        deinit {
            c_gfx.freeBitmap(c_bitmap)
        }
    }

    public class Font {
        var c_font: OpaquePointer?

        public init(path: String) throws {
            var err: UnsafePointer<CChar>? = nil
            c_font = c_gfx.loadFont(path, &err)
            try checkError(err)
        }

        // TODO: do Fonts need to be freed? it's unclear from the docs
        // deinit {

        // }
    }


// Static:

    public static func clear(_ color: Color) {
        c_gfx.clear(color.rawValue)
    }

    public static func drawText(_ message: String, x: Int, y: Int) {
        let _ = c_gfx.drawText(message, message.count, kUTF8Encoding,
                    Int32(x), Int32(y))
    }

    public static func setFont(_ font: Font) {
        c_gfx.setFont(font.c_font)
    }
}