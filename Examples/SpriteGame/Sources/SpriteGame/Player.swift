import Playdate

class Player {
    let plane: Sprite
    var collidedWithEnemyCallback: (() -> Void)?
    var downedEnemyCallback: (() -> Void)?

    init(centerX: Float, centerY: Float) throws {
        plane = Sprite()

        plane.setUpdateFunction(update)

        let planeImage = try Graphics.Bitmap(path: "images/player")
        plane.setImage(planeImage)

        plane.collideRect = Rect(x: 5, y: 5, width: Float(planeImage.width-10), height: Float(planeImage.height-10))
        plane.setCollisionResponseFunction { _, _ in .overlap }

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

        let (x, y) = plane.position

        let (_, _, collisions) = plane.moveWithCollisions(goalX: x + Float(dx), goalY: y + Float(dy))
        for c in collisions {
            let type = SpriteType(rawValue: c.other.tag)
            if type == .enemy {
                EnemyPlane.destroy(c.other)
                collidedWithEnemyCallback?()
            }
        }

        // Note: no need to free the collision info; Swift takes care of it
    }

    func fire() {
        let bounds = plane.bounds
        Bullet.spawn(x: bounds.x + bounds.width/2, y: bounds.y, hitEnemyCallback: downedEnemyCallback ?? {()})
    }
}
