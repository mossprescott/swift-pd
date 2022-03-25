# Sprite Game Example

A port of the SpriteGame example from the SDK, which shows off how the Swift types handle
object lifecycles: allocating and freeing Bitmaps and Sprites automatically when they're
no longer referenced.

There are a few changes compared to the SDK's original version:
- Button B produces continuous fire, because it's fun and because more sprites make a more
    interesting test
- The score is displayed in the corner of the screen. Did somebody forget to include that,
    after adding a font for it to the project?
- A couple of minor bug fixes

The code makes no attempt to preload bitmaps or fonts, instead just loading them as needed. That
makes a more interesting test of memory management, and the speed penalty doesn't matter in the
simulator. If we ever get this running on device, might want to fix that for better
performance/efficiency.

## Notes on the Swift port

It's not exactly clear how best to break up a moderately involved app like this one. I chose to put
each type of sprite into a separate .swift file, because it makes it easier to see how they compare to one another.

Even so, the total number of lines, including blanks and comments, is a little less than the
original single-file C version (about 410 versus 490). It might be interesting to compare that
with a Lua version.

To keep things simple, only the main class [`SpriteGame`](Sources/SpriteGame/SpriteGame.swift)
keeps track of any state. The rest of the files just contain functions to create and update one
type of sprite each. That ended up involving some callbacks, which could be considered overly fancy,
but it also demonstrates how Swift features like closures can be used to help organize even a small
codebase like this.

Using a Swift `enum` for sprite tags seems natural, but involves some manual mapping back and forth.
In fact, this game takes advantage of the untyped nature of those tags by storing either nothing,
an `enum` value, or a frame number, depending on the sprite. So in Swift you have to know
what the tag means based on the sprite you're looking at, and then you can interpret it into a nicer
type if you want.
