(function test() {
//    function All(){};
//    All.prototype.a = function() {
//    };
//    window.native =new All();
	var native ={
		a:function(){
			alert("ceshi")
		}
 	};
 	window.native =native;
})();
