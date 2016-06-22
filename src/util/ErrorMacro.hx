package util;

import httpstatus.*;
import haxe.macro.Context;
import haxe.macro.Expr;
using Lambda;

using tink.MacroApi;

class ErrorMacro {
	public static function build() {
		
		var fields = Context.getBuildFields();
		var field = fields.find(function(f) return f.name == 'error');
		
		// grab the Type: ErrorType from the function argument
		// not sure why Context.getType('util.Error.ErrorType') is not working
		var e = switch field.kind {
			case FFun(_.args[0].type.toType().sure() => TEnum(_.get() => e, _)): e;
			default: throw 'assert';
		}
		
		var cases = [];
		
		for(ctor in e.constructs) {
			
			var args = switch ctor.type {
				case TFun(args, _):
					args;
				default:
					[];
			}
			
			var values = switch args {
				case []: [macro $i{ctor.name}];
				default: [macro $i{ctor.name}($a{args.map(function(arg) return macro $i{arg.name})})];
			}
			
			var statusCode:HttpStatusCode = InternalServerError;
			var statusMessage:HttpStatusMessage = statusCode;
			
			switch ctor.meta.extract(':status') {
				case []:
					// do nothing, use default
				
				case [{params:[_.getInt().sure() => code]}]:
					statusCode = code;
					statusMessage = statusCode;
				
				case [{params:[_.getInt().sure() => code, _.getString().sure() => message]}]:
					statusCode = code;
					statusMessage = message;
				
				default:
					Context.error('Multiple @:status meta, or invalid parameters', ctor.pos);
			}
			
			var fields = args.map(function(arg) return {field: arg.name, expr: macro $i{arg.name}});
			fields.push({field: 'code', expr: macro $v{toSnakeCase(ctor.name)}});
			var data = EObjectDecl(fields).at();
			
			switch ctor.meta.extract(':data') {
				case []:
					// do nothing
					
				case [{params:[data]}]:
					// override the fields
					switch data.expr {
						case EObjectDecl(overrides):
							for(field in fields) switch overrides.find(function(f) return f.field == field.field) {
								case null: // override not found for this field
								case o: field.expr = o.expr;
							}
						default:
					}
				
				default:
					Context.error('Multiple @:data meta, or invalid parameters', ctor.pos);
			}
			
			cases.push({
				values: values,
				guard: null,
				expr: macro tink.core.Error.withData($v{statusCode}, $v{statusMessage}, $data, pos),
					// new OutgoingResponse(
					// 	new ResponseHeader($v{statusCode}, $v{statusMessage}, []),
					// 	haxe.Json.stringify($data)
					// )
			});
		}
		
		switch field.kind {
			case FFun(func): func.expr = macro return ${ESwitch(macro type, cases, null).at()};
			default: throw 'assert';
		}
		return fields;
	}
	
	static function toSnakeCase(v:String) {
		var r = '';
		for(i in 0...v.length) {
			var c = v.charAt(i);
			if(i == 0)
				r += c.toLowerCase();
			else if(c.toUpperCase() == c)
				r += '_' + c.toLowerCase();
			else
				r += c;
		}
		return r;
	}
	
	
}






