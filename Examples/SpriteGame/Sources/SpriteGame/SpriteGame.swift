import Playdate

class SpriteGame: App {
    let maxBackgroundPlanes = 10

    var score = 0
    var backgroundPlaneCount = 0
    var maxEnemies = 10
    var enemyCount = 0

    let player: Player

    /// "setupGame()"
    init() throws {
        // Note: no need to seed Swift's SystemRandomNumberGenerator

        try Background.setup()

        player = try Player(centerX: 200, centerY: 180)
        backgroundPlaneCount += 1

        // Note: to avoid a reference circularity, we wait until this instance is initialized, then
        // wire the callbacks.
        player.collidedWithEnemyCallback = {
            self.score -= 1
            self.enemyCount -= 1
        }
        player.downedEnemyCallback = {
            self.score += 1
            self.enemyCount -= 1
        }

        // Note: for the time being, all the images are being re-loaded constantly. Think of it as
        // a way of stress-testing memory management of Bitmaps and Sprites.
        // preloadImages()
    }

    func update() -> Bool {
        checkButtons()
        checkCrank()

        spawnEnemyIfNeeded()
        spawnBackgroundPlaneIfNeeded()
        Sprite.updateAndDrawSprites()

        Playdate.System.drawFPS(x: 0, y: 0)

        // Note: modified from the original; display the score at all times, using the helpfully
        // included font.
        guard let font = try? Graphics.Font(path: "fonts/namco") else {
            // TODO: preload
            fatalError("no font")
        }
        Graphics.setFont(font)
        Graphics.drawText("Score: \(score)", x: 5, y: 225)

        return true
    }

    private func checkButtons() {
        let buttons = System.getButtonState()
        // Note: modified from the original; B for continuous fire
        if buttons.pushed.contains(.a) || buttons.current.contains(.b) {
            player.fire();
        }
    }

    // cranking the crank changes the maximum number of enemy planes allowed
    private func checkCrank() {
        let change = System.getCrankChange()

        if change > 1 {
            maxEnemies += 1;
            if maxEnemies > 119 { maxEnemies = 119 }
            System.logToConsole("Maximum number of enemy planes: \(maxEnemies)")
        }
        else if change < -1  {
            maxEnemies -= 1;
            if maxEnemies < 0 { maxEnemies = 0 }
            System.logToConsole("Maximum number of enemy planes: \(maxEnemies)")
        }
    }

    private func spawnEnemyIfNeeded() {
        if enemyCount < maxEnemies {
            if Int.random(in: 0 ..< 120/maxEnemies) == 0 {
                EnemyPlane.spawn { self.enemyCount -= 1 }
                enemyCount += 1
            }
        }
    }

    private func spawnBackgroundPlaneIfNeeded() {
        if backgroundPlaneCount < maxBackgroundPlanes {
            if Int.random(in: 0 ..< 120/maxBackgroundPlanes) == 0 {
                BackgroundPlane.spawn { self.backgroundPlaneCount -= 1 }
                backgroundPlaneCount += 1
            }
        }
    }
}

enum SpriteType: UInt8 {
    case player = 1
    case bullet
    case enemy
}

@_dynamicReplacement(for: makeApp())
func myApp() throws -> App {
    Display.setRefreshRate(20)

    return try SpriteGame()
}
