//
//  NetWork.swift
//  ShareJewelry
//
//  Created by 超 V on 2018/4/9.
//  Copyright © 2018年 jinlihao. All rights reserved.
//

import UIKit
import HandyJSON

class NetWork: NSObject {
    
   
    
    ///  种类列表
    ///
    /// - Parameters:
    ///   - success: success description
    ///   - failure: failure description
    ///   - isShowHud: isShowHud description
    static func tobreeds_list(success : @escaping (Bool,[String : AnyObject])->(), failure : @escaping (Error)->(),isShowHud:Bool){
        VYCNetWorkRequest.sharedInstance.postRequest(urlString: IAP_breeds_list, params: nil, success: success, failure: failure,isShowHud:isShowHud)
    }
    
    
    ///  详情
    ///
    /// - Parameters:
    ///   - name: 种类名
    ///   - success: success description
    ///   - failure: failure description
    ///   - isShowHud: isShowHud description
    static func tobreed_iamge(name:String,success : @escaping (Bool,[String : AnyObject])->(), failure : @escaping (Error)->(),isShowHud:Bool){
        VYCNetWorkRequest.sharedInstance.postRequest(urlString: IAP_breed_images(name: name), params: nil, success: success, failure: failure,isShowHud:isShowHud)
    }
    
    
    
    
    
    

}

