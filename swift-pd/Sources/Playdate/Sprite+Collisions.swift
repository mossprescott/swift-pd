import CPlaydate

public typealias SpriteCollisionFilterProc = (Sprite, Sprite) -> Sprite.CollisionResponseType

extension Sprite {
    public func moveWithCollisions(goalX: Float, goalY: Float) -> (actualX: Float, actualY: Float, collisions: CollisionInfoList) {
        var actualX: Float = 0
        var actualY: Float = 0
        var len: Int32 = 0
        let collisions = Sprite.c_sprite.moveWithCollisions(c_ptr, goalX, goalY, &actualX, &actualY, &len)
        guard collisions != nil || len == 0 else { fatalError("nil result and length > 0: \(len)") }
        return (actualX: actualX, actualY: actualY, CollisionInfoList(collisions, Int(len)))
    }


    /// Wrapper for collision list results, which takes care of freeing them when they're no longer
    /// referenced.
    public class CollisionInfoList {
        fileprivate let mem: UnsafeMutablePointer<SpriteCollisionInfo>?
        fileprivate let len: Int

        init(_ mem: UnsafeMutablePointer<SpriteCollisionInfo>?, _ len: Int) {
            self.mem = mem
            self.len = len
        }

        deinit {
            if let mem = mem {
                let _ = System.realloc(ptr: mem, size: 0)
            }
        }
    }

    /// Read-only wrapper for collisions, which maps each value back to something useful.
    public struct CollisionInfo {
        let wrapped: UnsafePointer<SpriteCollisionInfo>

        init(wrapping: UnsafePointer<SpriteCollisionInfo>) {
            wrapped = wrapping
        }

        /// The sprite being moved
        public var sprite: Sprite {
            unstash(wrapped.pointee.sprite)
        }

        /// The sprite colliding with the sprite being moved
        public var other: Sprite {
            unstash(wrapped.pointee.other)
        }

        // TODO:
        // responseType: CollisionResponseType
        // overlaps: Bool
        // ti: Float
        // move: Point
        // normal: Vector
        // touch: Point
        // spriteRect: Rect
        // otherRect: Rect
    }

    /// Warning: these have to match the values for the C type!
    public enum CollisionResponseType: UInt32 {
        case slide = 0
        case freeze
        case overlap
        case bounce
    }
}

extension Sprite.CollisionInfoList: Collection {
    public typealias Index = Int
    public typealias Element = Sprite.CollisionInfo

    public var startIndex: Int { 0 }
    public var endIndex: Int { len }

    public subscript(index: Int) -> Sprite.CollisionInfo {
        // Note: "safe" to force the optional here because if there are no results this would be
        // an index-out-of-bounds error anyway.
        return Sprite.CollisionInfo(wrapping: &mem![index])
    }

    public func index(after i: Int) -> Int {
        return i+1
    }
}
