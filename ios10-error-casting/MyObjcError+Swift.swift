//
//  MyObjcError+Swift.swift
//  ios10-error-casting
//
//  Created by Kunihiko Ohnaka on 2016/11/19.
//  Copyright © 2016年 Kunihiko Ohnaka. All rights reserved.
//

import Foundation


extension MyObjcError : Error {
    public var _domain: String {
        return "MyObjcError"
    }
}

extension Error {
    var asMyObjcError: MyObjcError? {
        if let e = self as? MyObjcError {
            return e
        }
        if self._domain == MyObjcErrorDomain {
            return MyObjcError(rawValue: self._code)
        }
        return nil
    }
}

/*        return nil
        let nserror = self as NSError
        if nserror.domain == ""{
            
        }
        /*
        if let swiftError = self as? SwiftErrorA {
            return swiftError
        }
        if let swiftError = self as? SwiftErrorB {
            return swiftError
        }
        return SwiftErrorA.error1*/
    }
}*/

extension MyObjcError : _ObjectiveCBridgeableError {
    public init?(_bridgedNSError error: NSError) {
        guard error.domain == MyObjcErrorDomain else {
            return nil
        }
        guard let e = MyObjcError(rawValue: error.code) else {
            return nil
        }
        
        let assertCode = { (expected: MyObjcError, error:MyObjcError) -> MyObjcError in
            guard expected.rawValue == error.rawValue else {
                assertionFailure("Invalid error code. \(error.rawValue)")
                return MyObjcError.unknown
            }
            return error
        }
        switch e {
        case .unknown:
            self = assertCode(MyObjcError.unknown, e)
        case .error1:
            self = assertCode(MyObjcError.error1, e)
        case .error2:
            self = assertCode(MyObjcError.error2, e)
        }
    }
}

