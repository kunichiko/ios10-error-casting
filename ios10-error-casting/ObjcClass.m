//
//  ObjcClass.m
//  ios10-error-casting
//
//  Created by Kunihiko Ohnaka on 2016/11/18.
//  Copyright © 2016年 Kunihiko Ohnaka. All rights reserved.
//

#import "ObjcClass.h"

#import "ios10_error_casting-Swift.h"

@implementation ObjcClass

-(void)test1 {
    SwiftClass* swift = [[SwiftClass alloc] init];
    
    NSError* error100 = [swift tryCastToSwiftErrorAFromObjcWithError:[NSError errorWithDomain:@"ios10_error_casting.SwiftErrorA" code:50 userInfo:nil]];
    NSLog(@"error100       = %@", error100);
    NSLog(@"error100 class = %@", [error100 class]);

    NSError* error;
    [swift throwingSwiftErrorAAndReturnError:&error];
    NSLog(@"error       = %@", error);
    NSLog(@"error class = %@", [error class]);

    NSLog(@"****************");

    NSError* error2 = [swift tryCastToSwiftErrorAFromObjcWithError:error];
    NSLog(@"error       = %@", error2);
    NSLog(@"error class = %@", [error2 class]);

    NSLog(@"****************");

    [swift throwingSwiftErrorBAndReturnError:&error];
    NSLog(@"error       = %@", error);
    NSLog(@"error class = %@", [error class]);
    
    NSLog(@"****************");
    
    NSError* error3 = [swift tryCastToSwiftErrorAFromObjcWithError:error];
    NSLog(@"error       = %@", error3);
    NSLog(@"error class = %@", [error3 class]);

    [swift matchesSceneErrorType_ObjCWithError1:error2 error2:[NSError errorWithDomain:@"ios10_error_casting.SwiftErrorB" code:1 userInfo:nil]];
    
    if([error2 matchesSceneErrorType_ObjC:[NSError errorWithDomain:@"ios10_error_casting.SwiftErrorB" code:1 userInfo:nil]]) {
        NSLog(@"matched");
    } else {
        NSLog(@"not matched");
    }

    if([error2 matchesSceneErrorType_ObjC:error]) {
        NSLog(@"matched");
    } else {
        NSLog(@"not matched");
    }
}

@end
