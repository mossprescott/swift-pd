let TEXT_WIDTH = 86
let TEXT_HEIGHT = 16

// var x: Int
// var y: Int
// var dx: Int
// var dy: Int

/// Called once when the app is loaded, before the first call to update().
/// You can put code to do any one-time setup here.
func setup() {
    // font = Playdate.Graphics.loadFont(fontpath, &err);

}

/// Called once per frame to consume input and draw to the screen. If anything was drawn and the
/// screen needs to be updated by the sytem, return true.
func update() -> Bool {
    // TODO: statics
    let x = (400-TEXT_WIDTH)/2
    let y = (240-TEXT_HEIGHT)/2
    // let dx = 1
    // let dy = 2


    Playdate.Graphics.clear(.white)
    // // Playdate.Graphics.setFont(font)
    Playdate.Graphics.drawText("Hello World!", x: x, y: y)

    // // x += dx;
	// // y += dy;

	// // if ( x < 0 || x > LCD_COLUMNS - TEXT_WIDTH )
	// // 	dx = -dx;

	// // if ( y < 0 || y > LCD_ROWS - TEXT_HEIGHT )
	// // 	dy = -dy;

	Playdate.System.drawFPS(x: 0, y: 0)

	return true;
}
