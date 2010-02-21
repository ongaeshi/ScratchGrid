package  
{
	import mx.effects.easing.Back;
	/**
	 * ...
	 * @author 
	 */
	public class CellAttribute
	{
		private var background_:Boolean = false;
		private var backgroundColor_:uint = 0x00000000;
		
		private var hilightColor_:BackGroundColor = new BackGroundColor();
		
		private var incorrectColor_:BackGroundColor = new BackGroundColor();
		
		private var unsetColor_:BackGroundColor = new BackGroundColor();
		
		public function CellAttribute() 
		{			
		}

		// 背景色を設定
		public function get background():Boolean { return background_; }
		public function set background(value:Boolean):void { background_ = value; }
		
		public function get backgroundColor():uint { return backgroundColor_; }
		public function set backgroundColor(value:uint):void { backgroundColor_ = value; }
		
		// 値が変更されたときの点滅
		public function setChangeBlink():void 
		{
			hilightColor_.setEnableTimer(0x99FF99, 50);
		}
		
		// 不正解の時の色設定
		public function setIncorrect():void 
		{
			incorrectColor_.setEnable(0xff66cc);
		}
		
		public function clearIncorrect():void 
		{
			incorrectColor_.setDisable();
		}
		
		// 未設定時の色設定
		public function setUnsetBlink():void 
		{
			unsetColor_.setEnableTimer(0x3399ff, 20);
		}
		
		// 更新処理
		public function update():void 
		{
			hilightColor_.update();
			incorrectColor_.update();
			unsetColor_.update();
			
			if (hilightColor_.enable) {
				background = true;
				backgroundColor = hilightColor_.color;
			} 
			else if (unsetColor_.enable) {
				background = true;
				backgroundColor = unsetColor_.color;
			}
			else if (incorrectColor_.enable) {
				background = true;
				backgroundColor = incorrectColor_.color;
			} 
			else {
				background = false;
			}
		}
	}

}

import fl.motion.Color;

class BackGroundColor {
	private var enable_:Boolean = false;
	private var color_:uint = 0x0;
	private var frame_:int = 0;
	private var max_:int = 0;
	
	public function setEnable(color:uint):void 
	{
		enable_ = true;
		color_ = color;
		frame_ = 0;
	}
	
	public function setEnableTimer(color:uint, frame:int):void 
	{
		setEnable(color);
		frame_ = frame;
		max_ = frame;
	}
	
	public function setDisable():void 
	{
		enable_ = false;
	}
	
	public function update():void 
	{
		if (enable && frame_) {
			frame_--;
			
			if (frame_ == 0) {
				setDisable();
			}
		}
	}
	
	public function get enable():Boolean { return enable_; }
	
	public function get color():uint 
	{ 
		if (frame_) {
			// もう少し減衰曲線を格好よくしたいなあ。
			var rate:Number = frame_ / max_;
			return Color.interpolateColor(0xffffff, color_,  rate * rate);	
		} else
			return color_; 
	}
}