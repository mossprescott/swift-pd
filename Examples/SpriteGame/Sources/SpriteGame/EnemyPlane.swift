import Playdate

/// Manage the large planes that blunder in and helplessly wait to be shot down or bumped into.
/// Note, there's no state aside from the actual Sprite, so no instances of EnemyPlane.
enum EnemyPlane {
    /// "createEnemyPlane"
    static func spawn(departedCallback: @escaping () -> Void) {
        let plane = Sprite()

        plane.setUpdateFunction { sprite in update(plane: sprite, departedCallback: departedCallback) }
	    plane.setCollisionResponseFunction { _, _ in .overlap }  // Note: not actually used?

        // TODO: preload
        guard let planeImage = try? Graphics.Bitmap(path: "images/plane1") else {
            fatalError()
        }

        let w = planeImage.width
        let planeHeight = planeImage.height

        plane.setImage(planeImage)

        plane.collideRect = Rect(x: 0, y: 0, width: Float(w), height: Float(planeHeight))

        plane.moveTo(x: Float.random(in: 0 ..< 400) - Float(w)/2, y: Float.random(in: 0 ..< 30) - Float(planeHeight))

        plane.zIndex = 500
        Sprite.add(plane)

        plane.tag = SpriteType.enemy.rawValue
    }

    /// "updateEnemyPlane"
    private static func update(plane: Sprite, departedCallback: @escaping () -> Void) {
        let (x, y) = plane.position
        let newY = y + 4

        if let h = plane.getImage()?.height, newY > 400 + Float(h) {
            Sprite.remove(plane)
            departedCallback()
        }
        else {
            plane.moveTo(x: x, y: newY)
        }
    }

    public static func destroy(_ plane: Sprite) {
        let (x, y) = plane.position
        Explosion.spawn(x: x, y: y)

        Sprite.remove(plane)
    }
}
