//
//  SLBaseWebViewBridge.h
//  Pods-SLNativeJSMessage_Example
//
//  Created by lishuai on 2018/4/24.
//

#import <Foundation/Foundation.h>
#import "SLNativeBaseBridge.h"
#import <WebKit/WebKit.h>
typedef id (^SLWebbridgeCallback)(id params);
@interface SLBaseWebViewBridge : NSObject<SLNativeBaseBridge,WKScriptMessageHandler>

- (void)addMethod:(NSString *)methodName callBack:(SLWebbridgeCallback)callback;
@end
