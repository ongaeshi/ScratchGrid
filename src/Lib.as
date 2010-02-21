package  
{
	public class Lib {
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

		static public function to_s(x:Object):String
		{
		  if (x == null)
			return "null";
		  if (x.constructor === Array)
			return to_s_array(x);
		  if (typeof x == "string")
			return '"' + x + '"';
		  else
			return x.valueOf();
		}
		
		static public function trace2(x:Object):void
		{
			trace(to_s(x));
		}
		
		static public function isEmptyName(x:Object):Boolean
		{
			return (x == null || x == "" || x == " ");
		}
		
		static public function isValidName(x:Object):Boolean
		{
			return !isEmptyName(x);
		}
	}
}