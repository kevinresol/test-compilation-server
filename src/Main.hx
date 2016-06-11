package;

import sys.io.Process;

class Main {
	static function main() {
		var process = new Process('haxe', ['--wait', '6115']);
		compile('test/build.hxml');
		Sys.command('echo " " >> tests/MyTest.hx'); // make some modification
		compile('test/build.hxml');
		process.kill();
	}
	
	static function compile(hxml:String) {
		var exit = Sys.command('haxe', [hxml]);
		trace(exit);
	}
}