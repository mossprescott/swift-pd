import CPlaydate

public class Sprite {
    private let c_sprite: OpaquePointer?

    private init() {
        c_sprite = Playdate.c_api.sprite.pointee.newSprite()
    }

    public func update() {

    }

    public func draw() {

    }

    deinit {
        Playdate.c_api.sprite.pointee.freeSprite(c_sprite)
    }
}