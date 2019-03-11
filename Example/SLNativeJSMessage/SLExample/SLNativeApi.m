//
//  SLNativeApi.m
//  SLNativeJSMessage_Example
//
//  Created by Touker on 2018/4/25.
//  Copyright © 2018年 lishuailibertine. All rights reserved.
//

#import "SLNativeApi.h"

@implementation SLNativeApi

- (void)sl_helloWorld:(id)params callback:(void(^)(NSError *error,id responseDict))callback{
    NSLog(@"%@",params);
    callback(nil,@"js 你好");
}
- (void)sl_helloWorldA:(id)params callback:(void(^)(NSError *error,id responseDict))callback{
    NSLog(@"%@",params);
    callback(nil,@"js sl_helloWorldA");
}
- (void)dealloc{
    NSLog(@"释放了");
}
@end
