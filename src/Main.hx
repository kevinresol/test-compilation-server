package;

import Sys.*;
import sys.io.Process;
using haxe.io.Path;

class Main {
	static var server:Process;
	static function main() {
		server = new Process('haxe', ['--wait', '6115']);
		compile('tests/build.hxml');
		command('echo "" >> tests/MyTest.hx'); // make some modification
		compile('tests/build.hxml');
		server.kill();
		println('Test passed');
		exit(0);
	}
	
	static function compile(hxmlPath:String) {
		println('Compiling $hxmlPath...');
		var dir = hxmlPath.directory();
		var hxml = hxmlPath.withoutDirectory();
		var currentCwd = getCwd();
		setCwd(dir);
		var exitCode = command('haxe', [hxml]);
		if(exitCode != 0) {
			println('Compiled failed');
			println('Test failed');
			server.kill();
			exit(exitCode);
		} else println('Compiled $hxmlPath');
		setCwd(currentCwd);
	}
}