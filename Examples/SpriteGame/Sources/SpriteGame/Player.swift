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
        let bullet = Sprite();

        bullet.setUpdateFunction(updateBullet)

        // TODO: preload
        guard let bulletImage = try? Graphics.Bitmap(path: "images/doubleBullet") else {
            fatalError()
        }

        let w = bulletImage.width
        let bulletHeight = bulletImage.height

        bullet.setImage(bulletImage)

        bullet.collideRect = Rect(x: 0, y: 0, width: Float(w), height: Float(bulletHeight))

        // pd->sprite->setCollisionResponseFunction(bullet, playerFireCollisionResponse);

        let bounds = plane.bounds

        bullet.moveTo(x: bounds.x + bounds.width/2 - Float(w)/2, y: bounds.y)
        bullet.zIndex = 999
        Sprite.add(bullet)

        bullet.tag = SpriteType.playerBullet.rawValue
    }

    /// "updatePlayerFire"
    func updateBullet(bullet: Sprite) {
        let (x, y) = bullet.position
        let newY = y - 20

        if let h = bullet.getImage()?.height, newY < Float(-h) {
            Sprite.remove(bullet)
        }
        else {
            bullet.moveTo(x: x, y: newY)  // TODO moveWithCollisions

            // ...
        }
    }
}