//
//  LoginValidationService.swift
//  Carlisle
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import Foundation
import UtilCore
import Alice

extension LoginValidationProtocol {
    
    /// 用户名 验证
    func validateUsername( _ username:String)  -> ValidationResult {
        if username.count == 0 {
            return .empty
        }
        if username =~ Envs.regExp.username {
            return .ok(message: "正确")
        } else {
            return .failed(message:Envs.alertMsg(10001000))
        }
    }
    
    /// 密码 合法性验证
    func validatePassword( _ password:String)  -> ValidationResult {
        if password.count == 0 {
            return .empty
        }
        if password  =~ Envs.regExp.password {
            return .ok(message: "正确")
        } else {
            return .failed(message:Envs.alertMsg(10001003))
        }
    }
    
}

class LoginValidationService: LoginValidationProtocol {
    
}

