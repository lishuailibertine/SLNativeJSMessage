//
//  SLJSContextManage.m
//  Pods-SLNativeJSMessage_Example
//
//  Created by lishuai on 2018/4/25.
//

#import "SLJSContextManage.h"
#import "SLBaseWebViewBridge.h"
#import <objc/runtime.h>

NSString *const SLAPPIOSBRIDGENAME =@"_sl_native";
@interface SLJSContextManage()
@property (nonatomic,strong)JSContext *jsContext;
@property(nonatomic)dispatch_queue_t jsContextqueue;
@property (nonatomic, strong) WKUserContentController *userController;
@end

@implementation SLJSContextManage
- (instancetype)initContextManage:(UIWebView *)webview{
    if (self =[super init]) {
        self.jsContext = [webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        self.jsContext.exceptionHandler = ^(JSContext * con,JSValue * exception){
            NSLog(@"%@", exception);
            con.exception = exception;
        };
    }
    return self;
}
- (instancetype)initContextManageWithUserController:(WKUserContentController *)userController{
    if (self =[super init]) {
        self.userController =userController;
    }
    return self;
}
- (void)captureJSContextBrigeWithType:(SLJSContextManageType)jsContextManageType jsServer:(Protocol *)jsServer nativeImp:(id)nativeImp;{
    SLBaseWebViewBridge * webViewBridge =[[SLBaseWebViewBridge alloc] init];
    [self consoleProtocalsMethods:jsServer webViewBridge:webViewBridge nativeImp:nativeImp];
    if(jsContextManageType==SLJSContextManageType_UIWebview){
        self.jsContext[SLAPPIOSBRIDGENAME] = webViewBridge;
    }else{
        [self.userController addScriptMessageHandler:webViewBridge name:SLAPPIOSBRIDGENAME];
    }
}
- (void)consoleProtocalsMethods:(Protocol *)protocol webViewBridge:(SLBaseWebViewBridge *)webViewBridge nativeImp:(id)nativeImp{
    [self getMethod:protocol webViewBridge:webViewBridge nativeImp:nativeImp];
    unsigned int outCount = 0;
    Protocol * __unsafe_unretained _Nonnull*protocols =  protocol_copyProtocolList(protocol, &outCount);
    for (int i=0; i<outCount; i++) {
        Class class = NSClassFromString([NSString stringWithUTF8String:protocol_getName(protocols[i])]);
        if ([class isKindOfClass:[NSObject class]]) {
            continue;
        }
        [self consoleProtocalsMethods:protocols[i] webViewBridge:webViewBridge nativeImp:nativeImp];
    }
    free(protocols);
}
- (void)getMethod:(Protocol *)protocol webViewBridge:(SLBaseWebViewBridge *)webViewBridge nativeImp:(id)nativeImp{
    unsigned int numberOfMethods = 0;
    struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(protocol, YES, YES, &numberOfMethods);
    for (unsigned int j = 0; j < numberOfMethods; ++j) {
        struct objc_method_description methodDescription = methodDescriptions[j];
        NSString *selector_name = NSStringFromSelector(methodDescription.name);
        NSLog(@"%@",selector_name);
        SLWebbridgeCallback  WebbridgeCallback =^id(id params) {
            return [self SyncHandleNativeServer:nativeImp name:selector_name params:params];
        };
        [webViewBridge addMethod:selector_name callBack:WebbridgeCallback];
    }
    free(methodDescriptions);
}
#pragma mark --private
- (id)SyncHandleNativeServer:(id)object name:(NSString *)selectorName params:(id)params{
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"sl_%@:callback:",selectorName]);
    if (![object respondsToSelector:selector]) {
        NSLog(@"native is'not exist %@",selectorName);
        return @{};
    }
    __block id callback;
    void (*func)(id, SEL, id, id) = (void *)[object methodForSelector:selector];
    @try {
        func(object, selector, params,^(NSError *error,id responseObj){
            if (error) {
                callback =@{@"error":error.description};
            }else{
                callback= responseObj;
            }
        });
    }
    @catch (NSException *exception) {
        callback = [exception callStackSymbols];
    }
    return callback;
}
- (dispatch_queue_t)jsContextqueue{
    if (!_jsContextqueue) {
        _jsContextqueue = dispatch_queue_create("com.SL.jsContextqueue", DISPATCH_QUEUE_SERIAL);
    }
    return _jsContextqueue;
}
- (void)dealloc{
    if (self.userController) {
        [self.userController removeScriptMessageHandlerForName:SLAPPIOSBRIDGENAME];
    }
}
@end
