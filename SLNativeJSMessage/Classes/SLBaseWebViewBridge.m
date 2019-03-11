//
//  SLBaseWebViewBridge.m
//  Pods-SLNativeJSMessage_Example
//
//  Created by lishuai on 2018/4/24.
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
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    id body = message.body;
    if ([body isKindOfClass:[NSDictionary class]]) {
        NSDictionary * requestDict = (NSDictionary *)body;
        NSString * methodName = [requestDict objectForKey:@"Method"];
        NSString * callBackName = [requestDict objectForKey:@"iOS_Callback"];
        id param = [requestDict valueForKey:@"Params"];
        if (callBackName == nil || ([callBackName isKindOfClass:[NSString class]] &&callBackName.length==0)) {
            //Do nothing.
            return;
        }
         NSString * callBackFuncName = [NSString stringWithFormat:@"window.%@",callBackName];
        if (![[NSThread currentThread] isMainThread]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self wkCallback:methodName message:message param:param callBackFuncName:callBackFuncName];
            });
        }else{
           [self wkCallback:methodName message:message param:param callBackFuncName:callBackFuncName];
        }
    }
}
-(void)wkCallback:(id)methodName message:(WKScriptMessage *)message param:(id)param callBackFuncName:(NSString *)callBackFuncName{
    id _arguments;
    SLWebbridgeCallback WebbridgeCallback =[self.methodMap objectForKey:methodName];
    if(WebbridgeCallback ==nil){
        _arguments =@[[self convertToJSONData:@{@"error":@"method is not found"}]];
        NSString * javaScript;
        javaScript = [NSString stringWithFormat:@"%@(%@);",callBackFuncName,_arguments];
        [message.webView evaluateJavaScript:javaScript completionHandler:^(id _Nullable o, NSError * _Nullable error) {
            NSLog(@"WK Error: \n%@",error);
        }];
    }else{
        id arguments =WebbridgeCallback(param);
        _arguments =@[[self convertToJSONData:@{@"callback":arguments}]];
        NSString * javaScript;
        javaScript = [NSString stringWithFormat:@"%@(%@);",callBackFuncName,_arguments];
        [message.webView evaluateJavaScript:javaScript completionHandler:^(id _Nullable o, NSError * _Nullable error) {
            NSLog(@"WK Error: \n%@",error);
        }];
    }
}
//requestObject:@{@"_method_name":id};
-(void)callRouter:(JSValue *)requestObject callBack:(JSValue *)callBack{
    NSLog(@"%@",[requestObject toObject]);
    NSDictionary * requestDic = [requestObject toObject];
    if (![requestDic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"请按照标准定义结构");
        return;
    }
    NSString * methodName = [requestDic valueForKey:@"Method"];
    id param = [requestDic valueForKey:@"Params"];
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SLWebbridgeCallback WebbridgeCallback =[self.methodMap objectForKey:methodName];
            if(WebbridgeCallback ==nil){
                [callBack callWithArguments:@[[self convertToJSONData:@{@"error":@"method is not found"}]]];
            }else{
                id arguments =WebbridgeCallback(param);
                [callBack callWithArguments:@[[self convertToJSONData:@{@"callback":arguments}]]];
            }
        });
    }else{
        SLWebbridgeCallback WebbridgeCallback =[self.methodMap objectForKey:methodName];
        if(WebbridgeCallback ==nil){
            [callBack callWithArguments:@[[self convertToJSONData:@{@"error":@"method is not found"}]]];
        }else{
            id arguments =WebbridgeCallback(param);
            [callBack callWithArguments:@[[self convertToJSONData:@{@"callback":arguments}]]];
        }
    }
}
- (void)addMethod:(NSString *)methodName callBack:(SLWebbridgeCallback)callback{
    [self.methodMap setObject:callback forKey:methodName];
}
- (NSString*)convertToJSONData:(id)infoDict{
    if ([infoDict isKindOfClass:[NSString class]]) {
        return (NSString *)infoDict;
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = @"";
    if (! jsonData){
        NSLog(@"Got an error: %@", error);
    }else{
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}
@end
