//
//  SLNativeApi.h
//  SLNativeJSMessage_Example
//
//  Created by Touker on 2018/4/25.
//  Copyright © 2018年 lishuailibertine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLNativeApi : NSObject
- (void)sl_helloWorld:(id)params callback:(void(^)(NSError *error,id responseDict))callback;
@end
