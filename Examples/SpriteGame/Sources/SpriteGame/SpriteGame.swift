import Playdate

struct SpriteGame: App {
    /// "setupGame()"
    init() throws {
        //srand(secondsSincedEpoch)

        try Background.setup()

        // player = createPlayer(200, 180)
        // preloadImages()
    }

    func update() -> Bool {
        Playdate.System.drawFPS(x: 0, y: 0)

        // checkButtons()
        // checkCrank()

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
