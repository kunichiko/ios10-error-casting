//
//  SwiftClass.swift
//  ios10-error-casting
//
//  Created by Kunihiko Ohnaka on 2016/11/18.
//  Copyright © 2016年 Kunihiko Ohnaka. All rights reserved.
//

import Foundation

extension ObjcError : _ObjectiveCBridgeableError {
    public init?(_bridgedNSError error: NSError) {
        guard error.domain == "ObjcError" else {
            return nil
        }
        guard let e = ObjcError(rawValue: error.code) else {
            return nil
        }
        
        let normalize = { (expected: ObjcError, error:ObjcError) -> ObjcError in
            return expected.rawValue == error.rawValue ? expected : ObjcError.unknown
        }
        switch e {
        case .unknown:
            self = normalize(ObjcError.unknown, e)
        case .error1:
            self = normalize(ObjcError.error1, e)
        case .error100:
            self = normalize(ObjcError.error100, e)
        }
    }
}

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


    func throwingObjcError() throws {
        throw ObjcError.unknown
    }

    func throwingStructError() throws {
        throw StructError()
    }

    func handleError(_ error: Error) {
        print("\(error.asSwiftError)")
        
        
        if let error = error.asMyObjcError {
            switch error {
            case .unknown:
                print("u")
            case .error1:
                print("1")
            case .error2:
                print("2")
            }
        }
        if let error = error as? MyObjcError {
            switch error {
            case .unknown:
                print("u")
            case .error1:
                print("1")
            case .error2:
                print("2")
            }
        }
        print("\(error)")
        let nserror = error as NSError
        if nserror.domain == "ObjcError" {
            switch nserror.code {
            case ObjcError.error1.rawValue:
                print("")
            default:
                ()
            }
        }
    }
}

@objc
enum MySwiftError : Int, Error {
    case unknown
    case error1
    case error2
}

@objc(SwiftErrorA)
enum SwiftErrorA : Int, Error {
//enum SwiftErrorA : Error {
    case error1
    case error2
//    case error3 = 3
//    case error100 = 100
//    case unknown = 101

}

extension SwiftErrorA {
    var _domain: String {
        return "MyDomain"
    }
    var _code: Int {
        switch self {
        case .error1:
            return 1111
        case .error2:
            return 2222
        }
    }
}

@objc enum SwiftErrorB : Int, Error {
    case error1000 = 1000
    case error1001 = 1001
}

struct StructError : Error {
}

/*extension SwiftErrorA : _ObjectiveCBridgeableError {
    init?(_bridgedNSError error: NSError) {
        if error.domain == "SceneServerError" {
            return SwiftErrorA(rawValue: 0)
        }
        return nil
    }
}*/


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


