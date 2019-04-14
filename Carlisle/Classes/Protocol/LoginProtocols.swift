//
//  LoginProtocols.swift
//  Carlisle
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import Foundation

enum ValidationResult {
    case ok(message:String)
    case empty
    case validating
    case failed(message:String)
}

protocol LoginValidationProtocol {
    
    func validateUsername( _ username:String)  -> ValidationResult
    func validatePassword( _ password:String)  -> ValidationResult
}

protocol RegisterValidationProtocol :LoginValidationProtocol {
    /// 手机号 验证
    func validatePhone( _ username:String)  -> ValidationResult
    /// 短信验证码 合法性验证
    func validateMsgCode( _ msgCode:String)  -> ValidationResult
    /// 再次密码 合法性验证
    func validateRepeatPassword( _ password:String,repeatPassword:String)  -> ValidationResult
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
    var notEmpty: Bool {
        switch self {
        case .empty:
            return false
        default:
            return true
        }
    }
    var message:String{
        switch self {
        case .failed(let message):
            return message
        default:
            return ""
        }
    }
}
