import Playdate

struct SpriteGame: App {
    var maxEnemies = 10

    /// "setupGame()"
    init() throws {
        //srand(secondsSincedEpoch)

        try Background.setup()

        // player = createPlayer(200, 180)
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
    		// playerFire();
            System.logToConsole("fire!")
    	}
    }

    mutating func update() -> Bool {
        Playdate.System.drawFPS(x: 0, y: 0)

        // checkButtons()
        // checkCrank()
        checkButtons()
        checkCrank()

        // spawnEnemyIfNeeded()
        // spawnBackgroundPlaneIfNeeded()
        Sprite.updateAndDrawSprites()

        // background.image.draw(x: 0, y: 0)
        // background.draw()

        return true
    }
}

@_dynamicReplacement(for: makeApp())
func myApp() throws -> App {
    Display.setRefreshRate(20)

    return try SpriteGame()
}
