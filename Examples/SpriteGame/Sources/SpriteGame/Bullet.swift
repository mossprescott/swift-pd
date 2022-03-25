import Playdate

/// Manage bullets fired by the player's plane. Note, there's no state aside from the actual
/// Sprite, so no instances of Bullet.
enum Bullet {
    /// "playerFire"
    static func spawn(x: Float, y: Float, hitEnemyCallback: @escaping () -> Void) {
        let bullet = Sprite()

        bullet.setUpdateFunction { sprite in update(sprite, hitEnemyCallback) }

        // TODO: preload
        guard let bulletImage = try? Graphics.Bitmap(path: "images/doubleBullet") else {
            fatalError()
        }

        let w = bulletImage.width
        let bulletHeight = bulletImage.height

        bullet.setImage(bulletImage)

        bullet.collideRect = Rect(x: 0, y: 0, width: Float(w), height: Float(bulletHeight))
        bullet.setCollisionResponseFunction { _, _ in .overlap }

        bullet.moveTo(x: x, y: y)  // Note: the original example has a bug here that makes the bullets misaligned
        bullet.zIndex = 999
        Sprite.add(bullet)

        bullet.tag = SpriteType.playerBullet.rawValue
    }

    /// "updatePlayerFire"
    private static func update(_ bullet: Sprite, _ hitEnemyCallback: @escaping () -> Void) {
        let (x, y) = bullet.position
        let newY = y - 20

        if let h = bullet.getImage()?.height, newY < Float(-h) {
            Sprite.remove(bullet)
        }
        else {
            let (_, _, collisions) = bullet.moveWithCollisions(goalX: x, goalY: newY)

            var hit = false
            for c in collisions {
                let type = SpriteType(rawValue: c.other.tag)
                if type == .enemyPlane {
                    EnemyPlane.destroy(c.other)
                    hit = true
                    hitEnemyCallback()
                }
            }

            if hit {
                Sprite.remove(bullet)
            }

            // Note: no need to free the collision info; Swift takes care of it
        }
    }
}