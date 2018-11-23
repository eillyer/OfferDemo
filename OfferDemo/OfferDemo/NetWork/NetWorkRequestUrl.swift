//
//  NetWorkRequestUrl.swift
//  ShareJewelry
//
//  Created by 超 V on 2018/4/9.
//  Copyright © 2018年 jinlihao. All rights reserved.
//

import Foundation

#if DEBUG

let BaseUrl = "https://dog.ceo/api"
#else
let BaseUrl = "https://dog.ceo/api"
#endif

let IAP_breeds_list = "breeds/list"

func IAP_breed_images(name:String) -> String {
    return "breed/\(name)/images"
}
