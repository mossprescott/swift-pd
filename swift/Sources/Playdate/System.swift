import CPlaydate

public struct Buttons: OptionSet {
    public let rawValue: UInt32

    public init(rawValue val: UInt32) {
        rawValue = val
    }

    public static let left =  Buttons(rawValue: 1 << 0)
    public static let right = Buttons(rawValue: 1 << 1)
    public static let up =    Buttons(rawValue: 1 << 2)
    public static let down =  Buttons(rawValue: 1 << 3)
    public static let b =     Buttons(rawValue: 1 << 4)
    public static let a =     Buttons(rawValue: 1 << 5)

}

public enum System {
    private static var c_sys: playdate_sys {
        Playdate.c_api.system.pointee
    }

    /// See https://sdk.play.date/1.9.3/Inside%20Playdate%20with%20C.html#f-system.error
    ///
    /// Limitations: `message` should contain only ASCII characters, with no formatting.
    /// Use Swift string interpolation to construct strings.
    public static func error(_ message: String) {
        _error0(withUnsafeMutablePointer(to: &Playdate.c_api) { $0 }, message)
    }

    /// See https://sdk.play.date/1.9.3/Inside%20Playdate%20with%20C.html#f-system.logToConsole
    ///
    /// Limitations: `message` should contain only ASCII characters, with no formatting.
    /// Use Swift string interpolation to construct strings.
    public static func logToConsole(_ message: String) {
        // invokePrintf(c_api.system.pointee.logToConsole, message)
        _logToConsole0(withUnsafeMutablePointer(to: &Playdate.c_api) { $0 }, message)
    }

    public static func drawFPS(x: Int, y: Int) {
        c_sys.drawFPS(Int32(x), Int32(y))
    }

    public static func getButtonState() -> (current: Buttons, pushed: Buttons, released: Buttons) {
        var current: PDButtons = PDButtons(0)
        var pushed: PDButtons = PDButtons(0)
        var released: PDButtons = PDButtons(0)
        c_sys.getButtonState(&current, &pushed, &released)
        return (Buttons(rawValue: current.rawValue),
                Buttons(rawValue: pushed.rawValue),
                Buttons(rawValue: released.rawValue))
    }

    public static func getCrankChange() -> Float {
        return c_sys.getCrankChange()
    }

    public static func getCrankAngle() -> Float {
        return c_sys.getCrankAngle()
    }

    public static func isCrankDocked() -> Bool {
        return c_sys.isCrankDocked() != 0
    }

    public static func setCrankSoundsDisabled(_ flag: Bool) -> Bool {
        return c_sys.setCrankSoundsDisabled(flag ? 1 : 0) != 0
    }
}