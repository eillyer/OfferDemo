//
//  VYCNetWorkRequest.swift
//  ShareJewelry
//
//  Created by 超 V on 2018/4/9.
//  Copyright © 2018年 jinlihao. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

private let NetworkRequestShareInstance = VYCNetWorkRequest()
let HudText:String = NSLocalizedString("loading", comment: "")

class VYCNetWorkRequest: NSObject {
    
    var sessionManager:Alamofire.SessionManager!
    var hud:MBProgressHUD?
    class var sharedInstance : VYCNetWorkRequest {
        return NetworkRequestShareInstance
    }
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
}

extension VYCNetWorkRequest {
    
    //请求成功处理
    func handleSuccessResponse(response:[String : AnyObject],success : @escaping (_ isSuccess:Bool,_ response : [String : AnyObject])->()) -> () {
        if response["status"]as? String  == "success" {
            print(response)
            success(true,response)
        }else{
            AppControl.showTextHUD(text: (response["msg"] as? String) ?? NSLocalizedString("Error", comment: ""), superView: nil, afterDelay: 2)
            success(false,response)
        }
    }
    
    //对error的处理
    func handleFaild(error:Error,failure : @escaping (_ error:Error)->()) -> () {
        print("⚠️⚠️⚠️error:\(error)")
        let errorCode = (error as NSError).code
        failure(error)
        if errorCode == NSURLErrorNotConnectedToInternet{
            //            AppControl.showSystemAlertController(title:"网络无链接",message:"请查看下手机设置-无线局域网-使用WLAN与蜂窝移动的应用中是否设置允许使用网络")
            AppControl.showTextHUD(text: NSLocalizedString("Network without links", comment: ""), superView: nil, afterDelay: 0.5)
        }else{
            AppControl.showTextHUD(text: NSLocalizedString("Link error", comment: ""), superView: nil, afterDelay: 0.5)
        }
    }
    
    
    func getRequest(urlString: String, params : [String : Any]?, success : @escaping (_ isSuccess:Bool, _ response : [String : AnyObject])->(), failure : @escaping (_ error : Error)->(),isShowHud:Bool) {
        
        //使用Alamofire进行网络请求时，调用该方法的参数都是通过getRequest(urlString， params, success :, failture :）传入的，而success传入的其实是一个接受           [String : AnyObject]类型 返回void类型的函数
        if let Hud = hud {
            Hud.hide(animated: false)
        }
        
        if isShowHud {
            hud = AppControl.showHUD(text: HudText, superView: UIApplication.shared.windows.last!)
        }
        
        sessionManager.request(String.init(format: "%@/%@", BaseUrl,urlString), method: .get, parameters: VYCNetWorkRequest.parameters(params: params)).responseJSON { (response) in
            /*这里使用了闭包*/
            //当请求后response是我们自定义的，这个变量用于接受服务器响应的信息
            //使用switch判断请求是否成功，也就是response的result
            self.hud?.hide(animated: true)
            switch response.result {
            case .success:
                //当响应成功是，使用临时变量value接受服务器返回的信息并判断是否为[String: AnyObject]类型 如果是那么将其传给其定义方法中的success
                if let value = response.result.value as? [String: AnyObject] {
                    self.handleSuccessResponse(response: value, success: success)
                }
                
            case .failure(let error):
                self.handleFaild(error: error, failure: failure)
            }
        }
    }
    
    //POST
    func postRequest(urlString : String, params : [String : Any]?, success : @escaping (_ isSuccess:Bool,_ response : [String : AnyObject])->(), failure : @escaping (_ error : Error)->(),isShowHud:Bool) {
        
        
        if let Hud = hud {
            Hud.hide(animated: false)
        }
        
        if isShowHud {
            hud = AppControl.showHUD(text: HudText, superView: UIApplication.shared.windows.last!)
        }
        let URLStr = String.init(format: "%@/%@", BaseUrl,urlString)
        print(URLStr)
        let parameters = VYCNetWorkRequest.parameters(params: params)
        
        VYCNetWorkRequest.printoutUrl(urlString: URLStr, parameters: parameters!)
        sessionManager.request(URLStr, method:.post, parameters:parameters).responseJSON { (response) in
            
            print(response)
            self.hud?.hide(animated: true)
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    self.handleSuccessResponse(response: value, success: success)
                    let json = JSON(value)
                    print(json)
                }
            case .failure(let error):
                self.handleFaild(error: error, failure: failure)
            }
        }
    }
    
    //MARK: - 照片上传
    ///
    /// - Parameters:
    ///   - urlString: 服务器地址
    ///   - params: ["flag":"","userId":""] - flag,userId 为必传参数
    ///        flag - 666 信息上传多张  －999 服务单上传  －000 头像上传
    ///   - data: image转换成Data
    ///   - name: fileName
    ///   - success:
    ///   - failture:
    func upLoadImageRequest(urlString : String,imageName:[String], params:[String:String]?, data: [Data], fileNames: [String],success : @escaping (_ isSuccess:Bool,_ response : [String : AnyObject])->(), failure : @escaping (_ error : Error)->()){
        let headers = ["content-type":"multipart/form-data"]
        sessionManager.upload(
            multipartFormData: { multipartFormData in
                //666多张图片上传
                //                let flag = params!["flag"]
                //                let userId = params!["userId"]
                //
                //                multipartFormData.append((flag?.data(using: String.Encoding.utf8)!)!, withName: "flag")
                //                multipartFormData.append( (userId?.data(using: String.Encoding.utf8)!)!, withName: "userId")
                let params = VYCNetWorkRequest.parameters(params: params) as! [String:String]
                for key in params.keys{
                    let value = params[key]
                    multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
                }
                
                for i in 0..<data.count {
                    multipartFormData.append(data[i], withName: imageName[i], fileName: fileNames[i], mimeType: "image/png")
                }
                
        },
            to: String.init(format: "%@/%@", BaseUrl,urlString),
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: AnyObject]{
                            //                            success(value)
                            //                            let json = JSON(value)
                            self.handleSuccessResponse(response: value, success: success)
                        }
                    }
                case .failure(let error):
                    self.handleFaild(error: error, failure: failure)
                }
        }
        )
    }
    
    
    
    //接口的一些公共参数
    static func parameters(params:[String:Any]?) -> [String:Any]?{
        var parameters = [String : Any]()
        if let tempParams = params{
            parameters = tempParams
        }
        
        parameters["platform"]  = "1"
        
        if let myLanguage = UserDefaults.standard.value(forKey:"myLanguage") as? String {
            if myLanguage == "en" {
                parameters["language"] = "en";
            }else{
                parameters["language"] = "chs";
            }
        }else{
            parameters["language"]  = "en"
        }
        
        return parameters as [String : Any]
    }
    
    
    
    //打印url
    static func printoutUrl(urlString:String,parameters:[String : Any]){
        //        let keys = parameters.keys
        //        var tempArr = [String]()
        //        for key in keys {
        //            let keyAddValue = String.init(format: "%@=%@", key,(parameters[key] as? String)!)
        //            tempArr.append(keyAddValue)
        //        }
        //        print("\n***********************url***********************\n\(urlString)?\(tempArr.joined(separator: "&"))\n***********************")
    }
    
}
