import Playdate

/// Manage the small planes that fly harmlessly by underneath the action. Note, there's no state
/// aside from the actual Sprite, so no instances of BackgroundPlane.
enum BackgroundPlane {
    /// "createBackgroundPlane"
    static func spawn(departedCallback: @escaping () -> Void) {
        let plane = Sprite()

        plane.setUpdateFunction { sprite in update(plane: sprite, departedCallback: departedCallback) }

        // TODO: preload
        guard let planeImage = try? Graphics.Bitmap(path: "images/plane2") else {
            fatalError()
        }

        let w = planeImage.width
        let planeHeight = planeImage.height

        plane.setImage(planeImage)

        plane.moveTo(x: Float.random(in: 0 ..< 400) - Float(w)/2, y: -Float(planeHeight))
        plane.zIndex = 100
        Sprite.add(plane)
    }

    /// "updateBackgroundPlane"
    private static func update(plane: Sprite, departedCallback: @escaping () -> Void) {
        let (x, y) = plane.position
        let newY = y + 2

        if let h = plane.getImage()?.height, newY > 400 + Float(h) {
            Sprite.remove(plane)
            departedCallback()
        }
        else {
            plane.moveTo(x: x, y: newY)
        }
    }
}
