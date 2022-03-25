import Playdate

public enum Explosion {
    /// "createExplosion()"
    public static func spawn(x: Float, y: Float) {
        let sprite = Sprite()

        sprite.setUpdateFunction(update)

        sprite.setImage(loadImage(0))

        sprite.moveTo(x: x, y: y)

        sprite.zIndex = 2000
        Sprite.add(sprite)

        sprite.tag = 1  // using tag here for the frame number of the explosion animation
    }

    /// "updateExplosion()"
    private static func update(sprite: Sprite) {
        let frameNumber = sprite.tag + 1

        if frameNumber > 7 {
            Sprite.remove(sprite)
        }
        else {
            sprite.tag = frameNumber

            sprite.setImage(loadImage(Int(frameNumber)))
        }
    }

    // TODO: preload
    private static func loadImage(_ frame: Int) -> Graphics.Bitmap {
        do {
            return try Graphics.Bitmap(path: "images/explosion/\(frame)")
        }
        catch {
            fatalError("no image for explosion frame \(frame)")
        }
    }
}