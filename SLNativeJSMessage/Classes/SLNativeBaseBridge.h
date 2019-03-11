//
//  SLNativeBaseBridge.h
//  Pods-SLNativeJSMessage_Example
//
//  Created by lishuai on 2018/4/24.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol SLNativeBaseBridge <JSExport>
JSExportAs(callRouter, -(void)callRouter:(JSValue *)requestObject callBack:(JSValue *)callBack);
@end
