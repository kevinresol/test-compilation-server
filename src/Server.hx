package;

import minject.Injector;
import js.node.Cluster.instance as cluster;
import util.Error.error;

class Server {
	static var injector:Injector;
	
	static function main() {
		if(cluster.isMaster) {
		} else {
		}
  }
}