//
//  Carlisle_router.swift
//  Carlisle
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import Foundation
import URLNavigator
import UtilCore

public struct Carlisle_router {
    
    public static func initialize(navigator: NavigatorType) {
        
        /// 弹出登录界面
        navigator.handle("login".formatScheme()) { url, values ,context in
            let loginVc:Login_vc = CarlisleCore.storyboard.instantiateViewController()
            loginVc.present = true
            let loginNav = Base_Nav(rootViewController: loginVc)
            navigator.present(loginNav)
            return true
        }
        
        //注册
        navigator.register("register".formatScheme()) { url, values ,context in
            let registerVc:Register_vc = CarlisleCore.storyboard.instantiateViewController()
            return registerVc
        }
        
        //忘记密码
        navigator.register("forget".formatScheme()) { url, values ,context in
            let ForgetVc:Forget_vc = CarlisleCore.storyboard.instantiateViewController()
            return ForgetVc
        }
        
    }
}
