import CPlaydate

/// Bogus: this is isomorphic to the C type, just made public.
public struct Rect {
    var x: CFloat
    var y: CFloat
    var width: CFloat
    var height: CFloat

    public init(x: CFloat, y: CFloat, width: CFloat, height: CFloat) {
        self.x = x; self.y = y; self.width = width; self.height = height
    }

    init(cRect: PDRect) {
        self.x = cRect.x; self.y = cRect.y; self.width = cRect.width; self.height = cRect.height
    }

    func toC() -> PDRect {
        return PDRect(x: x, y: y, width: width, height: height)
    }
}


/// Note: using a class here to reflect the resource management that's happening; the underlying
/// LCDSprite is freed when an instance becomes garbage. Also, the API inherently uses mutation
/// to manipulate the sprite's state (if you choose to use it that way.) So maybe there's no
/// point trying to hide it.
public class Sprite {
    private static var c_sprite: playdate_sprite {
        Playdate.c_api.sprite.pointee
    }

    private let c_ptr: OpaquePointer?

    // Tricky: C function pointers are a drag. When a callback in installed, we actually set a generic
    // wrapper via the API, which uses `userdata` to get a handle to the (Swift) Sprite instance, then
    // calls through to one of these functions.
    fileprivate var updateFunction: () -> Void = {}
    fileprivate var drawFunction: (Rect, Rect) -> Void = { _, _ in () }

    public init() {
        c_ptr = Sprite.c_sprite.newSprite()

        // Get a pointer to this instance and stash it in the userdata field on the sprite.
        // Unretained because we assume the reference can never be used once the sprite is freed.
        Sprite.c_sprite.setUserdata(c_ptr, Unmanaged.passUnretained(self).toOpaque())
    }

    public var bounds: Rect {
        get {
            return Rect(cRect: Sprite.c_sprite.getBounds(c_ptr))
        }
        set {
            Sprite.c_sprite.setBounds(c_ptr, newValue.toC())
        }
    }

    public func setZIndex(_ zIndex: Int16) {
        Sprite.c_sprite.setZIndex(c_ptr, zIndex)
    }

    public func setUpdateFunction( _ update: @escaping () -> Void) {
        updateFunction = update
        Sprite.c_sprite.setUpdateFunction(c_ptr, updateGlue)
    }

    public func setDrawFunction( _ draw: @escaping (_ bounds: Rect, _ drawrect: Rect) -> Void) {
        drawFunction = draw
        Sprite.c_sprite.setDrawFunction(c_ptr, drawGlue)
    }

    public func markDirty() {
        Sprite.c_sprite.markDirty(c_ptr)
    }

    deinit {
        Sprite.c_sprite.freeSprite(c_ptr)
    }


// Static:

    public static func add(_ sprite: Sprite) {
       c_sprite.addSprite(sprite.c_ptr)
    }

    public static func updateAndDrawSprites() {
       c_sprite.updateAndDrawSprites()
    }

    // Recover a reference to the (Swift) instance from userdata.
    fileprivate static func unstash(_ c_ptr: OpaquePointer?) -> Sprite {
        let p = Sprite.c_sprite.getUserdata(c_ptr)!
        return Unmanaged<Sprite>.fromOpaque(p).takeUnretainedValue()
    }
}

private func updateGlue(c_ptr: OpaquePointer?) {
    Sprite.unstash(c_ptr).updateFunction()
}

private func drawGlue(c_ptr: OpaquePointer?, bounds: PDRect, drawrect: PDRect) {
    Sprite.unstash(c_ptr).drawFunction(Rect(cRect: bounds), Rect(cRect: drawrect))
}
