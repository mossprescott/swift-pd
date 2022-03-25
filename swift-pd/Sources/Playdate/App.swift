/// Implement this protocol to get your code called when the app starts.
/// `update()` gets called once per frame, and that's basicaly where everything needs to happen.
/// All other messages are optional and ignored by default.
///
/// Note: there's no `init()` message because you're expected to initialize your app when you
/// construct it, which should look something like this:
///
///    @_dynamicReplacement(for: makeApp())
///    func myApp() {
///        // any other initialization...
///
///        return MyApp()
///    }
///
/// TODO: implement the rest of the messages, so they're not ignored when someone actually wants
/// to handle them.
public protocol App {
    // We always install an update callback, so Lua never gets initialized. If we want to
    // write hybrid apps, we'll need this:
    // func initLua() {}

    func lock()
    func unlock()
    func pause()
    func resume()
    func terminate()
    func keyPressed(keyCode: CChar)
    func keyReleased(keyCode: CChar)
    func lowPower()

    /// Called once per frame to consume input and draw to the screen. If anything was drawn and the
    /// screen needs to be updated by the sytem, return true.
    mutating func update() -> Bool
}

/// Default, no-op implementations for everything except `update()`.
public extension App {
    func lock() {}
    func unlock() {}
    func pause() {}
    func resume() {}
    func terminate() {}
    func keyPressed(keyCode: CChar) {}
    func keyReleased(keyCode: CChar) {}
    func lowPower() {}
}
