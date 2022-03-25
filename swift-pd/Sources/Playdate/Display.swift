import CPlaydate

public enum Display {
    public static var width: Int {
        Int(Playdate.c_api.display.pointee.getWidth())
    }

    public static var height: Int {
        Int(Playdate.c_api.display.pointee.getHeight())
    }

    public static func setRefreshRate(_ rate: Float) {
        Playdate.c_api.display.pointee.setRefreshRate(Float32(rate))
    }
}