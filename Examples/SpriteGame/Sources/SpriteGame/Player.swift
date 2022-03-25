import Playdate

class Player {
    let plane: Sprite

    init(centerX: Float, centerY: Float) throws {
        plane = Sprite()

        plane.setUpdateFunction(update)

        let planeImage = try Graphics.Bitmap(path: "images/player")
        plane.setImage(planeImage)

        plane.collideRect = Rect(x: 5, y: 5, width: Float(planeImage.width-10), height: Float(planeImage.height-10))
        // plane.setCollisionResponseFunction()

        plane.moveTo(x: centerX, y: centerY)

        plane.zIndex = 1000
        Sprite.add(plane)

        plane.tag = SpriteType.player.rawValue
    }

    func update() {
        let (current, _, _) = System.getButtonState()

        var dx = 0
        var dy = 0

        if current.contains(.up) {
            dy = -4
        }
        else if current.contains(.down) {
            dy = 4
        }

        if current.contains(.left) {
            dx = -4
        }
        else if current.contains(.right) {
            dx = 4
        }

        // Note: the C version doesn't bother with this test
        if dx != 0 || dy != 0 {
            let (x, y) = plane.position

            // TODO: moveWithCollisions
            plane.moveTo(x: x + Float(dx), y: y + Float(dy))
        }
    }

    func fire() {
        let bounds = plane.bounds
        Bullet.spawn(x: bounds.x + bounds.width/2, y: bounds.y)
    }
}