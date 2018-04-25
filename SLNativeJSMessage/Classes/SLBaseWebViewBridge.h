//
//  SLBaseWebViewBridge.h
//  Pods-SLNativeJSMessage_Example
//
//  Created by Touker on 2018/4/24.
//

#import <Foundation/Foundation.h>
#import "SLNativeBaseBridge.h"
typedef id (^SLWebbridgeCallback)(id params);
@interface SLBaseWebViewBridge : NSObject<SLNativeBaseBridge>

- (void)addMethod:(NSString *)methodName callBack:(SLWebbridgeCallback)callback;
@end
