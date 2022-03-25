import CPlaydate

@_cdecl("eventHandler")
public func eventHandler(_ playdate: PlaydateAPI, _ event: PDSystemEvent, _ arg: Int32) -> Int32 {
    switch event {
    case kEventInit:
        Playdate.c_api = playdate

        do {
            appInstance = try makeApp()

            playdate.system.pointee.setUpdateCallback(updateCallback, nil)
        }
        catch RuntimeError.msg(let msg) {
            System.error("could not create the app: \(msg)")
        }
        catch let err {
            System.error("could not create the app: \(err)")
        }

    default:
        // TODO: pass all other events on to the App object
        System.logToConsole("unhandled event: \(event)")
    }

    return 0
}

private func updateCallback(_: UnsafeMutableRawPointer?) -> Int32 {
    return appInstance.update() ? 1 : 0
}

/// This gets replaced when the app library is loaded:
///    @_dynamicReplacement(for: makeApp())
///    func myApp() {
///        MyApp()
///    }
dynamic public func makeApp() throws -> App {
    fatalError("makeApp() replacement needed")
}

fileprivate var appInstance: App!


// TEMP
public protocol App {
    // dynamic public static func construct() -> App {
    //     fatalError("app() replacement needed")
    // }

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