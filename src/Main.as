import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import mx.controls.Alert;
import mx.controls.CheckBox;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.ClassFactory;
import mx.events.DataGridEvent;
import r1.deval.D;

private const VARIABLE_NUM:int = 6;
private var isUpdate_:Boolean = false;

private function init():void 
{
	// キャッシュを無効にしないと、同じコードを実行した時に結果が変わる？
	D.useCache(false);
	
	// 列情報の設定
	setupColumns();
	
	// 行情報の設定
	setupRows();

	// 表の更新
	updateDataGrid();
}

private function setupColumns():void
{
	var columns:Array = [];
	var c:DataGridColumn;
	
	for (var i:int = 1; i <= VARIABLE_NUM; i++) {
		var input:String = "TextInput" + i;
		c = new DataGridColumn();
		c.itemRenderer = new ClassFactory(ItemRenderer);
		columns.push(c);
	}
	
	c = new DataGridColumn();
	c.headerText = "Expect";
	c.dataField = "Expect";
	c.itemRenderer = new ClassFactory(ItemRenderer);
	columns.push(c);
	
	c = new DataGridColumn();
	c.headerText = "Result";
	c.dataField = "Result";
	c.itemRenderer = new ClassFactory(ItemRenderer);
	columns.push(c);
	
	Table.columns = columns;
}

private function setupRows():void
{
	var data:Array = [];
	
	for (var i:int = 0; i < 30; i++) {
		data.push(newObject());
	}
	
	Table.dataProvider = data;
}

private function updateDataGrid():void 
{
	for (var i:int = 0; i < VARIABLE_NUM; i++) {
		var input:String = "TextInput" + (i + 1);
		
		// 表示の切り替え
		Table.columns[i].visible = this["CheckBox" + (i + 1)].selected;
		
		// 列情報の更新
		Table.columns[i].headerText = this[input].text;
		Table.columns[i].dataField = this[input].text;
		
	}
		
	Table.columns[VARIABLE_NUM].visible = CheckBoxExpect.selected;
}

private function variable2context(v1:Object):Object
{
	var context:Object = new Object();
	
	for (var v:String in v1) {
		if (v != "mx_internal_uid" && v != "Result" && v != "SCP_attribute") {
			context[v] = convertObject(v1[v]);
		}
	}
	
	return context;
}

private function convertObject(v:String):Object
{
	return D.eval(v);
}

private function execScript():void 
{
	// 表の各行にスクリプトを実行
	for each (var vbl:Object in Table.dataProvider) {
		if (isAllVariableSet(vbl)) {
			var context:Object = variable2context(vbl);
			var result:Object = D.eval(SrcCode.text, null, context);
			context2variable(vbl, context, result);
			updateIncorrect(vbl);
		}
	}
}

private function execScriptAndUpdate():void 
{
	// スクリプトの実行
	execScript();
	
	// データの更新
	Table.dataProvider = Table.dataProvider;
}

private function isAllVariableSet(vbl:Object):Boolean
{
	var activeNum:int = 0;
	var setNum:int = 0;
	
	for (var i:int = 0; i < VARIABLE_NUM; i++) {
		var t:DataGridColumn = Table.columns[i];
		var flag:Boolean = isActiveVariableColumn(t);
		
		if (flag) {
			activeNum++;
			
			if (Lib.isValidName(vbl[t.dataField]))
				setNum++;
		}
	}
	
	if (activeNum == setNum)
		return true;
	
	// 一つ以上要素が入っていて、未設定部分を色付け
	if (setNum > 0) {
		setUnsetAttr(vbl);
	}
		
	return false;
}

private function setUnsetAttr(vbl:Object):void 
{
	for (var i:int = 0; i < VARIABLE_NUM; i++) {
		var t:DataGridColumn = Table.columns[i];
		
		if (isActiveVariableColumn(t) && Lib.isEmptyName(vbl[t.dataField]))
			vbl.SCP_attribute[i].setUnsetBlink();
	}
}

private function context2variable(vbl:Object, context:Object, result:Object):void 
{
	var next:Object;
	
	for (var i:int = 0; i < VARIABLE_NUM; i++) {
		var t:DataGridColumn = Table.columns[i];
		
		if (isActiveVariableColumn(t) && !Lib.isEmptyName(context[t.dataField])) {
			//trace(vbl[t.dataField], "<=", Lib.to_s(context[t.dataField]));
			
			next = Lib.to_s(context[t.dataField]);
		
			if (vbl[t.dataField] != next)
				vbl.SCP_attribute[i].setChangeBlink();
			
			vbl[t.dataField] = next;
		}
	}
	
	// Result更新
	next = Lib.to_s(result);

	if (vbl.Result != next)
		vbl.SCP_attribute[Table.columns.length - 1].setChangeBlink();

	vbl.Result = next;
}

private function updateIncorrect(vbl:Object):void 
{
	if (Lib.isValidName(vbl.Result) && Lib.isValidName(vbl.Expect) && vbl.Result != vbl.Expect) {
		vbl.SCP_attribute[Table.columns.length - 2].setIncorrect();
		vbl.SCP_attribute[Table.columns.length - 1].setIncorrect();
	} else {
		vbl.SCP_attribute[Table.columns.length - 2].clearIncorrect();
		vbl.SCP_attribute[Table.columns.length - 1].clearIncorrect();
	}
}

private function isActiveVariableColumn(t:DataGridColumn):Boolean
{
	return t.dataField != "Expect" && t.dataField != "Result" && t.visible;
}

private function inputKeyUp(e:KeyboardEvent):void 
{
	if (e.keyCode == Keyboard.F5)
		execScriptAndUpdate();
}

private function itemEditEnd(e:DataGridEvent):void 
{
	isUpdate_ = true;
}

private function checkBoxChange(e:Event):void
{
	// 変数名が空なのに、チェックボックスを有効にした場合、無効警告を出してチェックボックスはOFFにする
	var checkBox:CheckBox = CheckBox(e.currentTarget);
	
	if (checkBox.selected && 
		this[checkBox.name.replace(/CheckBox/, "TextInput")].text == "") {
		Alert.show("変数名が空です");
		checkBox.selected = false;
		return;
	}
	
	// 表の再生成
	updateDataGrid();
}

private function enterFrame(e:Event):void 
{
	// スクリプト実行
	if (isUpdate_) {
		if (CheckBoxAutoRun.selected)
			execScript();
		isUpdate_ = false;
	}
	
	// 属性の更新
	for each (var vbl:Object in Table.dataProvider) {
		for each (var attr:CellAttribute in vbl.SCP_attribute) {
			attr.update();
		}
	}
	
}

private function newObject():Object
{
	var obj:Object = new Object();
	
	obj.SCP_attribute = [];
	for (var i:int = 0; i < Table.columns.length; i++) {
		obj.SCP_attribute.push(new CellAttribute()); 
	}
	
	return obj;
}

private function outPutSettingChange(e:Event):void 
{
	
}
