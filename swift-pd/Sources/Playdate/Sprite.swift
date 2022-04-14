import CPlaydate

/// Bogus: this is isomorphic to the C type, just made public.
public struct Rect {
    public var x: CFloat
    public var y: CFloat
    public var width: CFloat
    public var height: CFloat

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
    static var c_sprite: playdate_sprite {
        Playdate.c_api.sprite.pointee
    }

    /// Retain a reference to every Sprite that gets added to the display list, so they won't
    /// become garbage.
    private static var displayList: Set<Sprite> = Set()

    let c_ptr: OpaquePointer?

    // Tricky: C function pointers are a drag. When a callback in installed, we actually set a generic
    // wrapper via the API, which uses `userdata` to get a handle to the (Swift) Sprite instance, then
    // calls through to one of these functions.
    fileprivate var updateFunction: (Sprite) -> Void = { _ in ()}
    fileprivate var drawFunction: (Sprite, Rect, Rect) -> Void = { _, _, _ in () }
    fileprivate var collisionResponseFunction: SpriteCollisionFilterProc? = nil

    /// Retain a reference to the Swift Bitmap, so it won't become garbage.
    private var image: Graphics.Bitmap? = nil

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

    public func moveTo(x: Float, y: Float) {
        Sprite.c_sprite.moveTo(c_ptr, x, y)
    }

    public func moveBy(dx: Float, dy: Float) {
        Sprite.c_sprite.moveBy(c_ptr, dx, dy)
    }

    public func setImage(_ image: Graphics.Bitmap, flip: Flip = .unflipped) {
        // Retain a reference to the old image until after the (C) Sprite no longer refers to it:
        withExtendedLifetime(self.image) {
            self.image = image

            Sprite.c_sprite.setImage(c_ptr, image.c_bitmap, LCDBitmapFlip(flip.rawValue))
        }
    }

    /// Might as well expose this, since we're holding onto it in order to keep it from being
    /// garbage-collected.
    public func getImage() -> Graphics.Bitmap? {
        return image
    }

    public var zIndex: Int16 {
        get {
            Sprite.c_sprite.getZIndex(c_ptr)
        }
        set {
            Sprite.c_sprite.setZIndex(c_ptr, newValue)
        }
    }

    public func markDirty() {
        Sprite.c_sprite.markDirty(c_ptr)
    }

    public var tag: UInt8 {
        get {
            Sprite.c_sprite.getTag(c_ptr)
        }
        set {
            Sprite.c_sprite.setTag(c_ptr, newValue)
        }
    }

    public func setUpdateFunction( _ update: @escaping () -> Void) {
        updateFunction = { _ in update() }
        Sprite.c_sprite.setUpdateFunction(c_ptr, updateGlue)
    }

    /// A variant taking the sprite instance as a first parameter
    public func setUpdateFunction( _ update: @escaping (Sprite) -> Void) {
        updateFunction = update
        Sprite.c_sprite.setUpdateFunction(c_ptr, updateGlue)
    }

    public func setDrawFunction( _ draw: @escaping (_ bounds: Rect, _ drawrect: Rect) -> Void) {
        drawFunction = { _, bounds, drawrect in draw(bounds, drawrect) }
        Sprite.c_sprite.setDrawFunction(c_ptr, drawGlue)
    }

    /// A variant taking the sprite instance as a first parameter
    public func setDrawFunction( _ draw: @escaping (_ sprite: Sprite, _ bounds: Rect, _ drawrect: Rect) -> Void) {
        drawFunction = draw
        Sprite.c_sprite.setDrawFunction(c_ptr, drawGlue)
    }

    public func setCollisionResponseFunction(_ f: SpriteCollisionFilterProc?) {
        collisionResponseFunction = f
        Sprite.c_sprite.setCollisionResponseFunction(c_ptr, collisionResponseGlue)
    }

    public var position: (x: Float, y: Float) {
        var x: Float = 0
        var y: Float = 0
        Sprite.c_sprite.getPosition(c_ptr, &x, &y)
        return (x, y)
    }

    public var collideRect: Rect {
        get {
            Rect(cRect: Sprite.c_sprite.getCollideRect(c_ptr))
        }
        set {
            Sprite.c_sprite.setCollideRect(c_ptr, newValue.toC())
        }
    }

    deinit {
        Sprite.c_sprite.freeSprite(c_ptr)
    }


// Static:

    public static func add(_ sprite: Sprite) {
        displayList.insert(sprite)
        c_sprite.addSprite(sprite.c_ptr)
    }

    public static func remove(_ sprite: Sprite) {
        c_sprite.removeSprite(sprite.c_ptr)
        displayList.remove(sprite)
    }

    public static func getCount() -> Int {
       return Int(c_sprite.getSpriteCount())
    }

    public static func updateAndDrawSprites() {
       c_sprite.updateAndDrawSprites()
    }

    // Recover a reference to the (Swift) instance from userdata.
    static func unstash(_ c_ptr: OpaquePointer?) -> Sprite {
        let p = Sprite.c_sprite.getUserdata(c_ptr)!
        return Unmanaged<Sprite>.fromOpaque(p).takeUnretainedValue()
    }

}

private func updateGlue(c_ptr: OpaquePointer?) {
    let sprite = Sprite.unstash(c_ptr)
    sprite.updateFunction(sprite)
}

private func drawGlue(c_ptr: OpaquePointer?, bounds: PDRect, drawrect: PDRect) {
    let sprite = Sprite.unstash(c_ptr)
    sprite.drawFunction(sprite, Rect(cRect: bounds), Rect(cRect: drawrect))
}

private func collisionResponseGlue(c_ptr: OpaquePointer?, other_c_ptr: OpaquePointer?) -> SpriteCollisionResponseType {
    let sprite = Sprite.unstash(c_ptr)
    let other = Sprite.unstash(other_c_ptr)
    if let f = sprite.collisionResponseFunction {
        return SpriteCollisionResponseType(f(sprite, other).rawValue)
    }
    else {
        return kCollisionTypeSlide  // 🤷
    }
}

extension Sprite: Hashable {
    public static func ==(lhs: Sprite, rhs: Sprite) -> Bool {
        lhs === rhs
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
