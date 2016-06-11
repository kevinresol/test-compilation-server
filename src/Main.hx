package;

import Sys.*;
import sys.io.Process;

class Main {
	static var process:Process;
	static function main() {
		process = new Process('haxe', ['--wait', '6115']);
		compile('tests', 'build.hxml');
		command('echo "" >> tests/MyTest.hx'); // make some modification
		compile('tests', 'build.hxml');
		process.kill();
		trace('Test passed');
		exit(0);
	}
	
	static function compile(cwd:String, hxml:String) {
		var currentCwd = getCwd();
		setCwd(cwd);
		var exitCode = Sys.command('haxe', [hxml]);
		if(exitCode != 0) {
			trace('Test failed');
			process.kill();
			exit(exitCode);
		}
		setCwd(currentCwd);
	}
}