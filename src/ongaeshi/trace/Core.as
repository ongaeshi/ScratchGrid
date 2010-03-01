package ongaeshi.trace 
{
	/**
	 * ...
	 * @author 
	 */
	public class Core
	{
		static private function to_s_array(array:Object):String
		{
		  var result:String = "";
		  result += "[";

		  for (var i:int = 0; i < array.length; i++) {
			result += to_s(array[i]) ;

			if (i != array.length - 1)
			  result += ", ";
		  }

		   result += "]";

		  return result;
		}
		
		static private function to_s_object(x:Object):String 
		{
			var result:String = "";
			var isSecond:Boolean = false;
			
			result += "{";
			for (var key:String in x) {
				if (isSecond)
					result += ", ";
				else
					isSecond = true;
				
				result += key + ":" + to_s(x[key]);
			}
			result += "}";
			return result;
		}

		static public function to_s(x:Object):String
		{
		  if (x == null)
			return "null";
		  else if (x.constructor === Object)
			return to_s_object(x);
		  else if (x.constructor === Array)
			return to_s_array(x);
		  else if (typeof x == "string")
			return '"' + x + '"';
		  else
			return x.valueOf();
		}
		
		static public function trace2(x:Object):void
		{
			trace(to_s(x));
		}
	}

}