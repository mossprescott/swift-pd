import Playdate

enum Background {
    static var y = 0
    static var image: Graphics.Bitmap!
    static var sprite: Sprite!

    static func setup() throws {
        image = try Graphics.Bitmap(path: "images/background")
        sprite = Sprite()

        sprite.setUpdateFunction(update)
        sprite.setDrawFunction { _, _ in draw() }

        sprite.bounds = Rect(x: 0, y: 0, width: 400, height: 240)
        sprite.zIndex = 0

        Sprite.add(sprite)
    }

    static func update() {
        y += 1
        if y > image.height {
            y = 0
        }

        sprite.markDirty()
    }

    static func draw() {
        image.draw(x: 0, y: y)
        image.draw(x: 0, y: y-image.height)
    }
}
