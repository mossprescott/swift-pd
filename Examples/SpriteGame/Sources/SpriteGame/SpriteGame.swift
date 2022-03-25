import Playdate

struct SpriteGame: App {
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

    // cranking the crank changes the maximum number of enemy planes allowed
    mutating func checkCrank() {
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

    func checkButtons() {
    	let buttons = System.getButtonState()
    	if buttons.pushed.contains(.a) || buttons.pushed.contains(.b) {
    		player.fire();
    	}
    }

    mutating func update() -> Bool {
        checkButtons()
        checkCrank()

        // spawnEnemyIfNeeded()
        // spawnBackgroundPlaneIfNeeded()
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
