This branch demonstrates that some cache are not being used by the compilation server, for unknown reasons.

#### How to reproduce:

0. `haxe -v --wait 6115`
0. `haxe build.hxml` twice (no need to modify source)
0. Note that some cache are skipped, some macros are run. But they should be, because nothing has changed

#### Try to remove import.hx and put the corresponding imports inside Error.hx and ErrorMacro.hx

Repeat the above steps. All caches are reused.