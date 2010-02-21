package  
{
	import flash.events.Event;
	import mx.controls.dataGridClasses.DataGridItemRenderer;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.events.FlexEvent;
	
	/**
	 * ...
	 * @author 
	 */
	public class ItemRenderer extends DataGridItemRenderer
	{
		public function ItemRenderer():void 
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (attribute().background) {
				background = true;
				backgroundColor = attribute().backgroundColor;
				
			} else {
				background = false;
			}
		}
		
		private function attribute():CellAttribute
		{
			return data.SCP_attribute[listData.columnIndex];
		}
	}

}