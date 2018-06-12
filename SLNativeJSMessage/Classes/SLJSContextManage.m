//
//  SLJSContextManage.m
//  Pods-SLNativeJSMessage_Example
//
//  Created by Touker on 2018/4/25.
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
- (instancetype)initContextManageWithWebview:(UIWebView *)webview{
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
- (void)registerRidgeWithRidgeType:(SLJSContextManageType)jsContextManageType jsServer:(Protocol *)jsServer nativeImp:(id)nativeImp{
    SLBaseWebViewBridge * webViewBridge =[[SLBaseWebViewBridge alloc] init];
    unsigned int numberOfMethods = 0;
    struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(jsServer, YES, YES, &numberOfMethods);
    for (unsigned int i = 0; i < numberOfMethods; ++i) {
        struct objc_method_description methodDescription = methodDescriptions[i];
        NSString *selector_name = NSStringFromSelector(methodDescription.name);
        SLWebbridgeCallback  WebbridgeCallback =^id(id params) {
            return [self SyncHandleNativeServer:nativeImp name:selector_name params:params];
        };
        [webViewBridge addMethod:selector_name callBack:WebbridgeCallback];
    }
    if(jsContextManageType==SLJSContextManageType_UIWebview){
         self.jsContext[SLAPPIOSBRIDGENAME] = webViewBridge;
    }else{
        [self.userController addScriptMessageHandler:webViewBridge name:SLAPPIOSBRIDGENAME];
    }
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
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(self.jsContextqueue, ^{
        @try {
            func(object, selector, params,^(NSError *error,id responseObj){
                if (error) {
                    callback =@{@"error":error.description};
                }else{
                    callback= responseObj;
                }
                dispatch_semaphore_signal(semaphore);
            });
        }
        @catch (NSException *exception) {
            callback = [exception callStackSymbols];
            dispatch_semaphore_signal(semaphore);
        }
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return callback;
}
- (dispatch_queue_t)jsContextqueue{
    if (!_jsContextqueue) {
        _jsContextqueue = dispatch_queue_create("com.SL.jsContextqueue", DISPATCH_QUEUE_SERIAL);
    }
    return _jsContextqueue;
}
@end
