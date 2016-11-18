//
//  SwiftClass.swift
//  ios10-error-casting
//
//  Created by Kunihiko Ohnaka on 2016/11/18.
//  Copyright © 2016年 Kunihiko Ohnaka. All rights reserved.
//

import Foundation


@objc class SwiftClass : NSObject {
    
    func throwingSwiftErrorA() throws {
        throw SwiftErrorA.error1
    }

    func throwingSwiftErrorB() throws {
        throw SwiftErrorB.error1000
    }

    func tryCastToSwiftErrorA(error: Error) -> SwiftErrorA? {
        guard let swiftError = error as? SwiftErrorA else {
            NSLog("Cast failed")
            return nil
        }
        NSLog("Cast succeeded")
        return swiftError
    }
    
    func tryCastToSwiftErrorAFromObjc(error: NSError) -> NSError? {
//        NSLog("\(error.asSwiftError)")
        let e: Error = error
        let e2 = e as? SwiftErrorA
        NSLog("\(e2)")
        guard let swiftError = self.tryCastToSwiftErrorA(error: error) else {
            return nil
        }
        switch swiftError {
        case .error1:
            print("error1")
        case .error2:
            print("error2")
//        case .error3:
//            print("error3")
        }
        return swiftError as NSError
    }

    @objc func matchesSceneErrorType_ObjC(error1: NSError, error2: NSError) -> Bool {
        let lhs = error1.asSwiftError as NSError
        let rhs = error2.asSwiftError as NSError
        return lhs.domain == rhs.domain && lhs.code == rhs.code
    }
}

@objc(SwiftErrorA)
enum SwiftErrorA : Int, Error {
    case error1 = 1
    case error2 = 2
//    case error3 = 3
//    case error100 = 100
//    case unknown = 101
}

@objc enum SwiftErrorB : Int, Error {
    case error1000 = 1000
    case error1001 = 1001
}



extension NSError {
    
    @objc func matchesSceneErrorType_ObjC(_ error: NSError) -> Bool {
        let lhs = self.asSwiftError as NSError
        let rhs = error.asSwiftError as NSError
        return lhs.domain == rhs.domain && lhs.code == rhs.code
    }
}

extension Error {
    var asSwiftError: Error {
        if let swiftError = self as? SwiftErrorA {
            return swiftError
        }
        if let swiftError = self as? SwiftErrorB {
            return swiftError
        }
        return SwiftErrorA.error1
    }
}
