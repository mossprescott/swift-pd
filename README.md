# Swift for Playdate

[Playdate](https://play.date) is a cool gaming console with limited memory and CPU power.
[Swift](https://swift.org) is a cool language which can be compiled to run efficiently on a wide
range of devices. This is a proof of concept of what it could be like to write Playdate apps
using Swift, but there are currenly many limitations.

Most importantly, you can only run apps *on the Playdate Simulator*, on an Apple Silicon Mac.

This repo implements the "Hello World" app from the SDK's C_API examples.


## Requirements

- On a Mac with Apple Silicon (i.e. M1)
- Install the [Playdate SDK](https://play.date/dev/) (version 1.9.2 works)
- Install `swiftc`, probably as part of [Xcode](https://developer.apple.com/xcode/) (I used 13.1)

## Build

```bash
$ ./make.sh
```

This script runs `pdc` to assemble any images, fonts, etc. from the directory `source/`,
into `HelloWorld.pdx` (which is actually a directory.)

Then it invokes `swiftc` to compile `source/main.swift`, writing `pdex.dylib` into the same
output directory.

## Run

```bash
$ open HelloWorld.pdx
```

Or just double-click the .pdx icon.

If you want to see your Swift `print()` output (or anything else written to stdout), then run the
simulator like this:
```bash
$ ~/"Developer/PlaydateSDK/bin/Playdate Simulator.app/Contents/MacOS/Playdate Simulator" HelloWorld.pdx
```

## Caveats

Your app built this way ***will not run on the Playdate hardware***, only in the simulator. It
would probably be possible to get something like this to work for building games to run on the
device, but it looks like it will take a lot more effort and knowledge.

If anything goes wrong, the simulator might refuse to load the app, or give a confusing error,
or just crash.

There are probably lots of Swift language/library features that won't work at all.
And lots that will work in the Simulator but don't really make sense for the device.

Only a tiny portion the the Playdate API is currently wrapped in nice Swift syntax. To do
anything very useful, we'll need at least the graphics/image and input APIs.
You can access everything via `Playdate.c_api`, but the types get pretty ugly.

This might actually work on an Intel Mac, or on Linux or Windows, with some changes. If you try
it and get somewhere, submit a PR.

I haven't tried to get Xcode to build the app. Imagine connecting the debugger to your Swift app
running in the simulator. And keep imagining it, because it's definitely not happening at the moment.

## Credit

@ericlewis worked out some details to get this off the ground. See
[this devforum thread](https://devforum.play.date/t/support-for-swift-runtime) for the full story.

This is only possible due to the amazing work of the Playdate and Swift teams. I don't know
how either of them would feel about this being a real thing, but it's thanks to them that even
an ugly hack like this can be done.
