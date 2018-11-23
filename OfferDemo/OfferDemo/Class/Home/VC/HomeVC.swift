//
//  HomeVC.swift
//  OfferDemo
//
//  Created by eillyer on 2018/11/22.
//  Copyright © 2018 eillyer. All rights reserved.
//

import UIKit

class HomeVC: VYCBaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var nameBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageBtn: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    var nameArr:[String] = [String]();
    var imageArr:[String] = [String]();

    var isNameOk = false;
    var isImageOk = false;

    var tempNameIndex:Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

 
        self.settingView()
        self.settingData()
        // Do any additional setup after loading the view.
    }
    func settingView () {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell");
        
    }
    func settingData () {
        nameNet();
    }
    
    func nameNet() {
        self.nameBtn.isEnabled = false;
        self.nameBtn.setTitle("加载中。。。", for: .normal);
        NetWork.tobreeds_list(success: { (success, dict) in
            print(dict);
            if success {
                if dict["message"] != nil {
                    if let arr = dict["message"] as? [String] {
                        for dogName in arr {
                            self.nameArr.append(dogName)
                        }
                    }
                    self.isNameOk = true;
                    self.tableView.reloadData();
                }
                self.nameBtn.setTitle("选择品种", for: .normal);
            }else{
                self.nameBtn.setTitle("重新加载", for: .normal);
            }
            self.nameBtn.isEnabled = true;
        }, failure: { (error) in
            print("=====================")

            print(error.localizedDescription)
            
            self.nameBtn.setTitle("重新加载", for: .normal);
            self.nameBtn.isEnabled = true;
        }, isShowHud: false);
    }
    
    func netSubImage(name:String)  {
        NetWork.tobreed_iamge(name: name, success: { (success , dict ) in
            if success {
                if dict["message"] != nil {
                    if let arr = dict["message"] as? [String] {
                        for dogimage in arr {
                            self.imageArr.append(dogimage)
                        }
                    }
                }
                self.isImageOk = true;
                self.imageBtn.setTitle(" ", for: .normal);
            }else{
                self.imageBtn.setTitle("重新加载", for: .normal);
            }
            self.imageBtn(self.imageBtn);
        }, failure: { (error ) in
            self.imageBtn.setTitle("重新加载", for: .normal);
        }, isShowHud: false);
    }
    
    @IBAction func nameNet(_ sender: UIButton) {
        if self.isNameOk {
            self.tableView.isHidden = !self.tableView.isHidden;
        }else{
            nameNet();
        }
    }
    
    @IBAction func imageBtn(_ sender: UIButton) {
        if  !self.isNameOk {
            return;
        }
        if self.isImageOk {
            imageView.sd_setImage(with: URL.init(string: self.imageArr[self.tempNameIndex]), placeholderImage: UIImage.init(named: "22"), options: [.retryFailed,.lowPriority], completed: nil)
            self.tempNameIndex += 1;
            if self.tempNameIndex > self.imageArr.count-1 {
                self.tempNameIndex = 0;
            }
        }else{
            self.netSubImage(name: (self.nameBtn.titleLabel?.text)!);
        }
        
    }
    
    // MARK: - tableView delegate -

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameArr.count;
    }
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!;
         let name = nameArr[indexPath.row]
        cell.textLabel?.text = name;
        return cell
    }
    
    //table的cell高度，可选方法
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.imageArr.removeAll();
        let name = self.nameArr[indexPath.row]
        self.nameBtn.setTitle(name, for: .normal);
        self.tableView.isHidden = true;
        self.netSubImage(name: name);
        self.isImageOk = false;
        self.tempNameIndex = 0;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.isHidden = true;
    }
}

