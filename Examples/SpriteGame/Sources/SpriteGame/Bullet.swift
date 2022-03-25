import Playdate

/// Manage bullets fired by the player's plane. Note, there's no state aside from the actual
/// Sprite, so no instances of Bullet.
enum Bullet {
    /// "playerFire"
    static func spawn(x: Float, y: Float) {
        let bullet = Sprite()

        bullet.setUpdateFunction(update)

        // TODO: preload
        guard let bulletImage = try? Graphics.Bitmap(path: "images/doubleBullet") else {
            fatalError()
        }

        let w = bulletImage.width
        let bulletHeight = bulletImage.height

        bullet.setImage(bulletImage)

        bullet.collideRect = Rect(x: 0, y: 0, width: Float(w), height: Float(bulletHeight))

        // pd->sprite->setCollisionResponseFunction(bullet, playerFireCollisionResponse);

        bullet.moveTo(x: x - Float(w)/2, y: y)
        bullet.zIndex = 999
        Sprite.add(bullet)

        bullet.tag = SpriteType.playerBullet.rawValue
    }

    /// "updatePlayerFire"
    static func update(bullet: Sprite) {
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