(function test(w) {
	var native ={
		isAndroid_ios:function(){  
			var u = navigator.userAgent, app = navigator.appVersion;  
			var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Linux') > -1; //android终端或者uc浏览器  
			var isiOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/); //ios终端  
			return isAndroid==true?true:false;  
		},
		check_webkit: function() {
             return void undefined !== w.webkit && void undefined !== w.webkit.messageHandlers  
        },
		callMessage:function(method,params,callback){
			var input ={
				Method :method,
				Params :params
            };
            var callbackName ="sl_iOS"+"_"+Date.now();
            w[callbackName] =function(argument){
            	callback(argument);
            	delete w[callbackName];
            };
            input.iOS_Callback =callbackName;
			if (!this.isAndroid_ios()){
				console.log("is iOS phone");
				if(this.check_webkit()){
					w.webkit.messageHandlers._sl_native.postMessage(input)
				}else{
					w._sl_native.callRouter(input,callback);
				}
				
			}else{
				console.log("is Android phone");
			}
		}
 	};
 	w.native =native;
})(window);
