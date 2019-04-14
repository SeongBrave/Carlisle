//
//  Carlisle_api.swift
//  Carlisle
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import Foundation
import UtilCore
import Alamofire
import ModelProtocol
import NetWorkCore

public enum Carlisle_api {
    
    /// 用户注册
    case register(phone: String, password: String,msgCode: String)
    ///登陆
    case login(phone: String, password: String)
    ///发送验证码
    case sendmsgcode(phone: String)
    ///修改密码
    case updatepassword(phone: String, password: String,msgCode: String)
    ///退出登陆
    case logout
}

extension Carlisle_api: TargetType {
    
    //请求路径
    public var path: String {
        switch self {
        case .register:
            return "user/register"
        case .login:
            return "user/login"
        case .sendmsgcode:
            return "user/sendmsgcode"
        case .updatepassword:
            return "user/updatepassword"
        case .logout:
            return "user/logout"
        }
    }
    
    //设置请求方式 get post等
    public var method: HTTPMethod {
        switch self {
        default:
            return .post
        }
    }
    
    /// 设置请求参数
    public var parameters: Parameters? {
        switch self {
        case let .register(phone, password ,msgCode):
            return ["phone": phone, "password": password, "msgCode": msgCode]
        case let .login(phone, password):
            return ["phone": phone, "password": password]
        case let .sendmsgcode(phone):
            return ["phone": phone]
        case let .updatepassword(phone, password ,msgCode):
            return ["phone": phone, "password": password, "msgCode": msgCode]
        default:
            return nil
        }
    }
}
