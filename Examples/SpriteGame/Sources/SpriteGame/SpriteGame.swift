import Playdate

class SpriteGame: App {
    let maxBackgroundPlanes = 10

    var maxEnemies = 10
    var backgroundPlaneCount = 0
    let player: Player

    /// "setupGame()"
    init() throws {
        //srand(secondsSincedEpoch)

        try Background.setup()

        player = try Player(centerX: 200, centerY: 180)
        backgroundPlaneCount += 1

        // preloadImages()
    }

    private func spawnBackgroundPlaneIfNeeded() {
        if backgroundPlaneCount < maxBackgroundPlanes {
            if Int.random(in: 0 ..< 120/maxBackgroundPlanes) == 0 {
                BackgroundPlane.spawn { self.backgroundPlaneDeparted() }
                backgroundPlaneCount += 1
            }
        }
    }

    private func backgroundPlaneDeparted() {
         backgroundPlaneCount -= 1
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

    private func checkButtons() {
        let buttons = System.getButtonState()
        // Note: modified from the original; B for continuous fire
        if buttons.pushed.contains(.a) || buttons.current.contains(.b) {
            player.fire();
        }
    }

    func update() -> Bool {
        checkButtons()
        checkCrank()

        // spawnEnemyIfNeeded()
        spawnBackgroundPlaneIfNeeded()
        Sprite.updateAndDrawSprites()

        // System.logToConsole("sprites: \(Sprite.getCount())")

        Playdate.System.drawFPS(x: 0, y: 0)

        return true
    }
}

enum SpriteType: UInt8 {
    case player = 1
    case playerBullet
    case enemyPlane
}

@_dynamicReplacement(for: makeApp())
func myApp() throws -> App {
    Display.setRefreshRate(20)

    return try SpriteGame()
}
