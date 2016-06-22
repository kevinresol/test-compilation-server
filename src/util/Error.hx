package util;

import tink.core.Error as TinkError;

#if !display @:build(util.ErrorMacro.build()) #end
class Error {

	public static function error(type:ErrorType, ?pos:PosInfos):TinkError
		return new TinkError('Display', pos);
	
}

enum ErrorType {
	@:status(400) BadRequest;
}