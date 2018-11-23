//
//  AppControl.swift
//  ShareJewelry
//
//  Created by 超 V on 2018/4/9.
//  Copyright © 2018年 jinlihao. All rights reserved.
//

import UIKit
import MBProgressHUD

let UserDefaults_appVersion = "local_AppVersion"



//func handle(image:UIImage) -> () {
//
//}

class AppControl: NSObject {
    //单例
//    let handle = (handelImage(image:UIImage) -> ())
    static let shared = AppControl()
    
    var currentViewController:VYCBaseViewController?
    
    var versonNew:String?
    
    // Make sure the class has only one instance
    // Should not init or copy outside
    private override init() {}
    
    override func copy() -> Any {
        return self // SingletonClass.shared
    }
    
    override func mutableCopy() -> Any {
        return self // SingletonClass.shared
    }
    
    // Optional
    func reset() {
        // Reset all properties to default value
    }
    
    /*
     NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
     CFShow(infoDictionary);
     // app名称
     NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
     // app版本
     NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

 */
    
    static func getSuperVC() -> UIViewController {
        let keywindow = UIApplication.shared.keyWindow
        let firstView: UIView = (keywindow?.subviews.first)!
        let secondView: UIView = firstView.subviews.first!
        let vc = AppControl.viewForControllers(view: secondView);
        return vc!
    }
    
    static func viewForControllers(view:UIView)->UIViewController?{
        var next:UIView? = view
        repeat{
            if let nextResponder = next?.next, nextResponder is UIViewController {
                return (nextResponder as! UIViewController)
            }
            next = next?.superview
        }while next != nil
        return nil
    }
    

    
    static func getAppVersion() -> String{
        let app_info = Bundle.main.infoDictionary
        let app_Version = app_info!["CFBundleShortVersionString"]
        return app_Version as! String
    }
    
    
    /// 是否显示引导页
    static func isShowGuideVC() -> Bool{
        let local_appVersion = UserDefaults.standard.value(forKey: UserDefaults_appVersion) as? String
        let current_appVersion  = AppControl.getAppVersion()
        if local_appVersion == current_appVersion {
            return false
        }
        return true
    }
    
    static func showTextHUD(text:String,superView:UIView?,afterDelay:TimeInterval) -> (){
        let superV = superView ?? UIApplication.shared.windows.last
        let HUD = MBProgressHUD.showAdded(to: superV!, animated: true)
        HUD.mode = .text
        HUD.margin = 12
        HUD.removeFromSuperViewOnHide = true
        HUD.detailsLabel.text = text
        HUD.detailsLabel.font = UIFont.boldSystemFont(ofSize: 14)
        HUD.hide(animated: true, afterDelay: afterDelay)
    }
    
    static func showHUD(text:String,superView:UIView) -> (MBProgressHUD){
        //初始化对话框，置于当前的View当中
        let HUD = MBProgressHUD.showAdded(to: superView, animated: true)
        HUD.removeFromSuperViewOnHide = true
        HUD.label.text = text
        return HUD;
    }
    
    
    
    
    static func showSystemAlertView(title:String?,message:String?) ->UIAlertView {
        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: ""))
        alertView.show()
        return alertView
    }
    
    static func showSureAlertController(title:String?,message:String?,viewController:UIViewController,handle:@escaping ()->()){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let sureAlertAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (alertAction) in
            handle()
        }
        alertController.addAction(sureAlertAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func showSystemAlertController(title:String?,message:String?,viewController:UIViewController,handle:@escaping ()->()){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let sureAlertAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (alertAction) in
            handle()
        }
        let cancelAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(sureAlertAction)
        alertController.addAction(cancelAlertAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    ///获取IP
    static func getIPAddresses() -> String? {
        var addresses = [String]()
        
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }
    
    static func checkUpdataWithAppStoreVersion(appStoreVersion:String?) -> Bool{
        let currentVersion = getAppVersion()
        if let appStoreVersion = appStoreVersion{
            if appStoreVersion.caseInsensitiveCompare(currentVersion) == .orderedDescending{
                return true
            }
        }
        return false
    }
    
}
