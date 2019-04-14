//
//  CarlisleCore.swift
//  Carlisle
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import Foundation


/// 本模块的名称， 本模块的storyboard 名称必须 与模块名称相同 ,已经用于静态资源的加载回用到
let modularName = "Carlisle"

public  class  CarlisleCore {
    
    public static var sharedInstance :  CarlisleCore {
        struct Static {
            static let instance :  CarlisleCore =  CarlisleCore()
        }
        return Static.instance
    }
    
    /// 登陆模块的storyboard
    public static var storyboard:UIStoryboard {
        get{
            return UIStoryboard(name: modularName, bundle:  CarlisleCore.bundle)
        }
    }
    
    ///供其他模块使用
    public static var bundle:Bundle?{
        get{
            guard let bundleURL = Bundle(for:self).url(forResource: modularName, withExtension: "bundle") else {
                return nil
            }
            guard let bundle = Bundle(url: bundleURL) else {
                return nil
            }
            return bundle
        }
    }
}

