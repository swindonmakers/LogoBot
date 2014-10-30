

module Assembly(name, title, call) {
	echo(str(" { 'type':'assembly', 'name':'",name,"', 'title':'",title,"', 'call':'",call,"', "));
	if ($children > 0) {
		children();
	}
	echo(str(" 'contains': [ "));
}

module Vitamin(name, title, call) {
	echo(str(" { 'type':'vitamin', 'name':'",name,"', 'title':'",title,"', 'call':'",call,"', "));
	if ($children > 0) {
		children();
	}
	echo(str(" 'contains': [ "));
}

module Attr(name,value) {
	echo(str(" '",name,"':'",value,"' , "));
}

module End() {
	echo(str(" {} ] }, "));
}


Assembly("LogoBot", "LogoBot Basic Robot", "LogoBotAssembly(PenLift=false)")
	Attr("note","this is a little note\n\n");

	Assembly("Wheel", "Left Wheel", "Wheel()");
	
		Vitamin("Wheel", "Wheel", "Wheel_STL()") { 
			Attr("author","damo");
			Attr("src","http://ebay.com");
			Attr("cost","0.89");
		}
		
		End();

	End();

	Assembly("Wheel", "Right Wheel", "Wheel()");

	End();
	
End();