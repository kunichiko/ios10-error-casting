//
//  ObjcClass.h
//  ios10-error-casting
//
//  Created by Kunihiko Ohnaka on 2016/11/18.
//  Copyright © 2016年 Kunihiko Ohnaka. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const ObjcErrorDomain;

typedef NS_ENUM(NSInteger, ObjcError) {
    ObjcErrorUnknown                                = 0,
    ObjcErrorError1                                 = 1,
    ObjcErrorError100                               = 100
};

@interface ObjcClass : NSObject

-(void)test1;

-(void)testSwiftStructError;

- (BOOL)throwingObjcErrorWithCode:(NSInteger)code error:(NSError *__autoreleasing *)error;

- (void)handleError:(NSError*)error;

@end

extern NSString *const MyObjcErrorDomain;

typedef NS_ENUM(NSInteger, MyObjcError) {
    MyObjcErrorUnknown      = 0,
    MyObjcErrorError1       = 1,
    MyObjcErrorError2       = 2
};
