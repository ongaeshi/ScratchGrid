package  
{
	public class Lib {
		static public function isEmptyName(x:Object):Boolean
		{
			if (x == null)
				return true;
			else if (typeof x == "string") {
				if (x == "" || x == " ")
					return true;
			}
			
			return false;
		}
		
		static public function isValidName(x:Object):Boolean
		{
			return !isEmptyName(x);
		}
	}
}