//
//  SLBaseWebViewBridge.m
//  Pods-SLNativeJSMessage_Example
//
//  Created by Touker on 2018/4/24.
//

#import "SLBaseWebViewBridge.h"

@interface SLBaseWebViewBridge()
@property (nonatomic, strong) NSMutableDictionary *methodMap;
@end

@implementation SLBaseWebViewBridge
- (NSMutableDictionary *)methodMap{
    if (!_methodMap) {
        _methodMap =[NSMutableDictionary dictionary];
    }
    return _methodMap;
}
//requestObject:@{@"_method_name":id};
-(void)callRouter:(JSValue *)requestObject callBack:(JSValue *)callBack{
    NSLog(@"%@",[requestObject toObject]);
    NSDictionary * requestDic = [requestObject toObject];
    if (![requestDic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"请按照标准定义结构");
        return;
    }
    for (NSString *methodName in requestDic.allKeys) {
        id param =[requestDic objectForKey:methodName];
        if (![[NSThread currentThread] isMainThread]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                SLWebbridgeCallback WebbridgeCallback =[self.methodMap objectForKey:methodName];
                if(WebbridgeCallback ==nil){
                    [callBack callWithArguments:@[@{@"error":@"method is not found"}]];
                }else{
                    id arguments =WebbridgeCallback(param);
                    [callBack callWithArguments:@[@{@"callback":arguments}]];
                }
            });
        }else{
            SLWebbridgeCallback WebbridgeCallback =[self.methodMap objectForKey:methodName];
            if(WebbridgeCallback ==nil){
                [callBack callWithArguments:@[@{@"error":@"method is not found"}]];
            }else{
                id arguments =WebbridgeCallback(param);
                [callBack callWithArguments:@[@{@"callback":arguments}]];
            }
        }
    }
}
- (void)addMethod:(NSString *)methodName callBack:(SLWebbridgeCallback)callback{
    
    [self.methodMap setObject:callback forKey:methodName];
}
@end
