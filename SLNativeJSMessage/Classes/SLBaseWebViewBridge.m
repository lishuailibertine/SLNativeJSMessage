//
//  SLBaseWebViewBridge.m
//  Pods-SLNativeJSMessage_Example
//
//  Created by Touker on 2018/4/24.
//

#import "SLBaseWebViewBridge.h"

@implementation SLBaseWebViewBridge

-(void)callRouter:(JSValue *)requestObject callBack:(JSValue *)callBack{
    NSLog(@"%@",[requestObject toObject]);
}
@end
