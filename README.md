# SLNativeJSMessage
#JS与原生(IOS)通信组件

# 通信组件的由来
随着h5在原生页面中用到的越来越平凡(市面上流行的APP都可以看到它的身影 ),在我们用h5去与原生通信的时，h5会有许多需要原生提供业务功能的地方；这时候如果是几个简单的功能，很可能我们就会把业务处理放到webview中去做处理了，但是真实的情况并不是这样，一个项目大概会有至少几十个调用原生功能的地方，这时候你那么去做势必会让类负担很重，并且维护的成本也非常的高; 我们需要的一个管理这些功能的地方；写这个组件希望它可以达到一些目的:让h5的开发人员使用起来很方便；让我们原生开发的人员不需要关心那些琐碎的桥接等等；维护起来很方便; 如果生产中出现问题它可以做到容错不至于APP无法使用,并把无法通信的原因告诉h5;

# 通信组件如何去设计
1、我想让它不仅能在UIWebview内核中使用，它还可以在最新的内核WKwebview中使用;
2、需要一个管理JS上下文的类，这个类与webview打交道，除了注册我们业务层需要的功能，它还负责把h5的消息传递给原生;
# 通信组件通过时序图去说明

![图片描述](https://github.com/lishuailibertine/SLNativeJSMessage/blob/master/Prepare.jpg)

![图片描述](https://github.com/lishuailibertine/SLNativeJSMessage/blob/master/SendMessage.jpg)

# 通信组件在h5端如何使用

举例: 调用原生摄像头,(callCamera)
``` 
//native:挂载在window上的对象(详情请看中间件)，主要提供callMessage给h5调用
//param1:调用的原生对应的功能(声明的方法)
//param2:调用原生对应功能的入参(任意类型)
//param3:原生返回给h5的callback结果
native.callMessage("callCamera",{""},function callback(argument) {
                alert(argument);
});
``` 
举例:其他功能

```
//其他
native.callMessage("功能2",{""},function callback(argument) {
               console.log(原生返回的消息)；
});
```

#中间件介绍(NativeJS)
主要担任的职责:
1、提供轻便易用的接口给H5使用;
2、整合兼容UIWebview与WKWebview内核;
3、其他

# 通信组件在原生端如何使用

```
//UIWebview使用
[self.jsContextManage captureJSContextBrigeWithType:SLJSContextManageType_UIWebview jsServer:@protocol(SLJSApi) nativeImp:nativeApi];

//WKWebview使用
[self.jsContextManage captureJSContextBrigeWithType:SLJSContextManageType_WKWebview jsServer:@protocol(SLJSApi) nativeImp:nativeApi];
```