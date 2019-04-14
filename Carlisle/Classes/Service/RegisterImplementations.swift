//
//  RegisterImplementations.swift
//  Carlisle
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import Foundation
import UtilCore
import Alice

class RegisterImplementations: RegisterValidationProtocol {
    
    /// 手机号 验证
    func validatePhone( _ phone:String)  -> ValidationResult {
        if phone.count == 0 {
            return .empty
        }
        if phone =~ Envs.regExp.phone {
            return .ok(message: "正确")
        } else {
            return .failed(message:Envs.alertMsg(10001001))
        }
    }
    
    /// 短信验证码 合法性验证
    func validateMsgCode( _ msgCode:String)  -> ValidationResult {
        if msgCode.count == 0 {
            return .empty
        }
        if msgCode.count == 4 {
            return .ok(message: "正确")
        } else {
            return .failed(message:Envs.alertMsg(10001002))
        }
    }
    
    /// 再次密码 合法性验证
    func validateRepeatPassword( _ password:String,repeatPassword:String)  -> ValidationResult{
        if repeatPassword.count == 0 {
            return .empty
        }
        if password == repeatPassword {
            return .ok(message: "正确")
        } else {
            return .failed(message:Envs.alertMsg(10001004))
        }
    }
    
    /// 手机号 email
    func validateEmail( _ email:String)  -> ValidationResult {
        if email.count == 0 {
            return .empty
        }
        if email =~ Envs.regExp.email {
            return .ok(message: "正确")
        } else {
            return .failed(message:Envs.alertMsg(10001005))
        }
    }
}
