//
//  VYCBaseViewController.swift
//  ShareJewelry
//
//  Created by 超 V on 2018/4/8.
//  Copyright © 2018年 jinlihao. All rights reserved.
//

import UIKit

class VYCBaseViewController: UIViewController {
    
    /// 动态改变状态栏颜色
    var navigationBarColor:UIColor?
    var statuBarStyle:UIStatusBarStyle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.groupTableViewBackground
        if let nav = self.navigationController{
            if nav.viewControllers.count>1{
                showBackBtn()
            }
        }
//
//        //获取最新版 版本号
//        if AppControl.shared.versonNew == nil {
//            NetWork.toLogic_config_get_version(success: { (success ,dict) in
//                let dicts = dict["data"] as! [String:Any]
//                AppControl.shared.versonNew = dicts["version_ios"] as? String;
//                self.checkUpdata()
//            }, failure: { (error ) in
//            }, isShowHud: false);
//        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppControl.shared.currentViewController = self
        if let navigationBarColor = self.navigationBarColor {
            self.navigationController?.navigationBar.barTintColor = navigationBarColor
        }
    }
    
    @objc func becomeActive() {

    }

    
    /// showRightBarButtonItem
    func showRightBarButtonItem(title:String,titleColor:UIColor) {
        let rightBarButtonItem = UIBarButtonItem(title: title, style: UIBarButtonItem.Style.done, target: self, action: #selector(rightBtnClick))
        rightBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),NSAttributedString.Key.foregroundColor:titleColor], for: .normal)
        rightBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),NSAttributedString.Key.foregroundColor:titleColor], for: .selected)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    /// showRightBarButtonItem
    func showRightBarButtonItem(title:String?,image:UIImage,titleColor:UIColor) {

        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        btn.addTarget(self, action:#selector(rightBtnClick), for: UIControl.Event.touchUpInside)
        if title != nil  {
            btn.setTitle(title, for: UIControl.State.normal);
        }
        btn.setImage(image, for: UIControl.State.normal);
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15);
        btn.imageView?.contentMode = .scaleAspectFit;
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn);
        

    }
    
    //RightBarButtonItem点击，子类集成
    @objc func rightBtnClick() {
        
    }
    
    //leftBarButtonItem点击，子类集成
    @objc func leftBackButtonClick(){
        
    }
    
    /// 返回键
    func showBackBtn() {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 44))
        btn.setImage(UIImage.init(named: "返回"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.contentMode = .center
        btn.addTarget(self, action: #selector(dismissvc), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    @objc func dismissvc() {
        dismissVc(animated: true)
    }
    
    func showCustomBackBtn() {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 44))
        btn.setImage(#imageLiteral(resourceName: "返回"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.contentMode = .center
        btn.addTarget(self, action: #selector(leftBackButtonClick), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    
    //改变状态栏样式
    func setStatuBarStyle(barstyle:UIStatusBarStyle) {
        self.statuBarStyle = barstyle
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let  statuBarStyle = self.statuBarStyle{
            return statuBarStyle
        }
        return .lightContent
    }
    
    @objc func dismissVc(animated: Bool) {
        if let NvcCount = self.navigationController?.viewControllers.count{
            if NvcCount > 1{
                self.navigationController?.popViewController(animated: animated)
                return
            }
        }
        
        self.dismiss(animated: animated, completion: nil)
    }
    
    func presentLoginVc()  {
//        let loginNav = VYCCustomNavigationController(rootViewController: LoginViewController())
//        present(loginNav, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    ///跳订单页面
    func popToOderViewController() {
        let tabBarController = self.tabBarController!
        self.navigationController?.popToRootViewController(animated: false)
        tabBarController.selectedIndex = 2
    }
    
    
    /// 跳首页指定页 0,1,2..
    func popToRootViewController(index:Int) {
        let tabBarController = self.tabBarController!
        self.navigationController?.popToRootViewController(animated: false)
        tabBarController.selectedIndex = index
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
