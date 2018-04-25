(function test(w) {
	var native ={
		isAndroid_ios:function(){  
			var u = navigator.userAgent, app = navigator.appVersion;  
			var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Linux') > -1; //android终端或者uc浏览器  
			var isiOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/); //ios终端  
			return isAndroid==true?true:false;  
		},
		callMessage:function(params,callback){
			if (!this.isAndroid_ios()){
				console.log("is iOS phone");
				w._sl_native.callRouter(params,callback);
			}else{
				console.log("is Android phone");
			}
		}
 	};
 	w.native =native;
})(window);
