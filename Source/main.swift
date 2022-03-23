let TEXT_WIDTH = 86
let TEXT_HEIGHT = 16

var x = (400-TEXT_WIDTH)/2
var y = (240-TEXT_HEIGHT)/2
var dx = 1
var dy = 2

/// Called once when the app is loaded, before the first call to update().
/// You can put code to do any one-time setup here.
func setup() {
    // font = Playdate.Graphics.loadFont(fontpath, &err);
}

/// Called once per frame to consume input and draw to the screen. If anything was drawn and the
/// screen needs to be updated by the sytem, return true.
func update() -> Bool {
    Playdate.Graphics.clear(.white)
    // Playdate.Graphics.setFont(font)
    Playdate.Graphics.drawText("Hello World!", x: x, y: y)

    x += dx
	y += dy

	if x < 0 || x > Int(LCD_COLUMNS) - TEXT_WIDTH {
        dx = -dx
    }

	if y < 0 || y > Int(LCD_ROWS) - TEXT_HEIGHT {
		dy = -dy
    }

	Playdate.System.drawFPS(x: 0, y: 0)

	return true;
}
