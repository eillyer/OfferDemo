//
//  EillyerTools.swift
//  ORGetSwift1
//
//  Created by eillyer on 2018/4/24.
//  Copyright © 2018年 eillyer. All rights reserved.
//

import Foundation
import UIKit


// MARK: - 字符处理
extension String {
    
    /// 删除第几个字符
    ///
    /// - Parameter indexs: 第几个（非下标）
    /// - Returns: 删除后的字符串
    func TORemoveAtIndex(indexs:Int) -> String {
        var str = self;
        str.remove(at: str.index(before: String.Index.init(encodedOffset: indexs)));
        return str;
        
    }
    
    
    /// 字符串截取从下标开始（包含）
    ///
    /// - Parameter indexs: 位数
    /// - Returns: 截取后的字符
    func TOSubFromIndex(indexs:Int) -> String {
        let strString: NSString = self as NSString
        let end = String(strString.substring(from: indexs));
        return end;
    }
    
    /// 字符串截取从下标终止（不包含）
    ///
    /// - Parameter indexs: 位数
    /// - Returns: 截取后的字符
    func TOSubToIndex(indexs:Int) -> String {
        let strString: NSString = self as NSString
        let end = String(strString.substring(to: indexs));
        return end;
    }
    
    
    /// 调整文本的行间距
    ///
    /// - Parameters:
    ///   - text: 字符
    ///   - rowHeight: 行距
    /// - Returns: textV.attributedText = setString
    func TOHeightForRowInTextView(rowHeight:Float) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle.init();
        paragraphStyle.lineSpacing = CGFloat(rowHeight);
        let setString = NSMutableAttributedString.init(string: String(self));
        setString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: self.count));
        return setString;
    }
    
    
    /// 字符串转数组
    ///
    /// - Parameter text: 分隔符
    /// - Returns: 数组
    func TOZhuanArray(text:String) -> Array<Any> {
        var idsArr:[String] = Array.init();
        for item  in self.components(separatedBy: text) {
            idsArr.append(item);
        }
        return idsArr;
    }
    
//    func sizeWithText(font: CGFloat, size: CGSize?) -> CGRect {
//        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: font)]
//        let option = NSStringDrawingOptions.usesLineFragmentOrigin
//        let rect:CGRect = self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: option, attributes: attributes, context: nil)
//        return rect;
//    }
    
}
// MARK: - 数组处理
extension Array {
    
    
    /// 数组转字符串
    ///
    /// - Parameter text: 分隔符号
    /// - Returns: 字符
    func TOZhuanStr(text:String) -> String {
        var idsArr:[String] = Array.init() as! [String];
        for item in self {
            idsArr.append(item as! String);
        }
        let ids:String = idsArr.joined(separator: text)
        return ids;
    }
}
// MARK: -NSString扩展
extension NSString {
    //当前日期yyyy-MM-dd
    class func TOStringDateNow() -> NSString {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        return dateFormatter.string(from: date) as NSString
    }
    //当前月yyyy-MM
    class func TOStringDateNowFind() -> NSString {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = Date()
        return dateFormatter.string(from: date) as NSString
    }
    //当前具体时间yyyy-MM-dd-HH-mm-ss
    class func TOStringDateNowTime() -> NSString {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let date = Date()
        return dateFormatter.string(from: date) as NSString
    }
    //得到年
    func TOgetStrDateYear() -> NSString {
        return self.substring(to: 4) as NSString
    }
    //得到月
    func TOgetStrDateMonth() -> NSString {
        return self.substring(with: NSRange.init(location: 5, length: 2)) as NSString
    }
    //得到日
    func TOgetStrDateDay() -> NSString {
        return self.substring(with: NSRange.init(location: 8, length: 2)) as NSString
    }
    
    /// 时间段计算出小时
    /// self 为开始时间
    /// - Parameter endTime: 结束时间
    /// - Returns: 距离多少小时
    func TOstarTimeToEndTimeWithHour(endTime:String) -> Float {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let star = dateFormatter.date(from: self as String)
        let end = dateFormatter.date(from: endTime)
        let to = end?.timeIntervalSince(star!)
        return Float(to!/3600.0)
    }
    
    /// 格式转换
    ///
    /// - Returns: 格式转换
    func TOZhuanUTF8() -> NSString {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.init(charactersIn: "`#%^{}\"[]|\\<>+ ").inverted)! as NSString
    }
    
    /// 浮点数
    ///
    /// - Returns: 结果
    func TOisPureFloat() -> Bool {
        let scan = Scanner.init(string: self as String)
        var val:Float = 0
        let isFloat = scan.scanFloat(&val)&&scan.isAtEnd
        return isFloat
    }
    
    /// 整数
    ///
    /// - Returns: 结果
    func TOisPureInts() -> Bool {
        let scan: Scanner = Scanner(string: self as String)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    /// 判断字符串是否是数字
    ///
    /// - Returns: 是否是数字
    func TOstringIsInteger() -> Bool {
        return TOisPureInts()||TOisPureFloat()
    }
    
    /// 文字高度
    ///
    /// - Parameters:
    ///   - maxSize: 最大size
    ///   - font: 字体大小
    /// - Returns: 自适应后的大小
    func TOsizeOfText(maxSize:CGSize,font:UIFont) -> CGSize {
        return self.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:font], context: nil).size
    }
    
    /// NSDate转NSString
    ///
    /// - Parameter date: 时间
    /// - Returns: 时间
    class func TOstringFromDate(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    /// NSString转NSDate
    ///
    /// - Returns: 时间
    func TOdateFromString() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self as String)!
    }
    
    /// 汉子转拼音
    ///
    /// - Parameter china: 中文
    /// - Returns: 拼音
    class func TOchinaeseZhuanPinyin(china:String) -> String {
        let mutableString = NSMutableString(string: china)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    ///  根据字符串直接转成数组
    ///
    /// - Returns: 直接字符串  如：@“asdf”
    //    转为@[@"a",@"s",@"d",@"f"]
    func TOstrZhuanArr() -> NSMutableArray {
        var array1 : [String] = [String]()
        for indexs in 0 ..< self.length {
            let str = self.substring(with: NSRange.init(location: indexs, length: 1))
            array1.append(str)
        }
        return array1 as! NSMutableArray
    }
    
    //    字符串邮箱校验
    func TOisEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with:email)
    }
    //    字符串手机号校验
    func TOisPhone(email: String) -> Bool {
        let emailRegex = "^(1(([3456789][0-9])|(47)|[8][0126789]))\\d{8}$"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with:email)
    }
    //     英文字母和数字校验
    func TOisEnwordOrNumWord(email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9]{6,16}$"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with:email)
    }
    //    url校验
    func TOisURL(email: String) -> Bool {
        let emailRegex = "^((https|http|ftp|rtsp|mms)?://)?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?(([0-9]{1,3}\\.){3}[0-9]{1,3}|([0-9a-z_!~*'()-]+\\.)*([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.[a-z]{2,6})(:[0-9]{1,4})?((/?)|(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with:email)
    }
    //    邮编效验
    func TOisZipcode(email: String) -> Bool {
        let emailRegex = "[1-9]d{5}(?!d)"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with:email)
    }
    //    身份证效验
    func TOisIdentity(email: String) -> Bool {
        let emailRegex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with:email)
    }
    //    字符串名字校验
    func TOisSingle(email: String) -> Bool {
        let emailRegex = "^([\\u4e00-\\u9fa5]+|([a-zA-Z]+\\s?)+)$"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with:email)
    }
    //    字符串中文校验
    func TOisChinese(email: String) -> Bool {
        let emailRegex = "(^[\\u4e00-\\u9fa5]+$)"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with:email)
    }
}



// MARK: - view的处理
extension UIView {
    /**
     切圆角和切半角
     
     @param fload 弧度
     @param wid borwid
     @param color borcolor
     
     */
    func TOsetBorder (R:CGFloat,wid:CGFloat,color:UIColor) {
        self.layer.borderColor = color.cgColor;
        self.layer.borderWidth = wid;
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = R;
    }
    
    /**
     @param fload 弧度
     @param wid borwid
     @param color borcolor
     @param corners corners
     */
    func TOsetVorderRounding(R:CGFloat,wid:CGFloat,color:UIColor,corners:UIRectCorner) {
        
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize.init(width: R , height: R));
        let maskLayer = CAShapeLayer.init();
        maskLayer.path = maskPath.cgPath;
        self.layer.mask = maskLayer;
        self.clipsToBounds = true;
        //    类型共有以下几种:
        //    * UIRectCornerTopLeft
        //    * UIRectCornerTopRight
        //    * UIRectCornerBottomLeft
        //    * UIRectCornerBottomRight
        //    * UIRectCornerAllCorners
    }
    
    //背景颜色的渐变
    //isH:横向渐变还是纵向渐变
    func TOsetCAColorStarToEnd(starColor:UIColor,endColor:UIColor,isH:Bool) {
        let gradientLayer = CAGradientLayer.init();
        gradientLayer.colors = [starColor.cgColor,endColor.cgColor];
        gradientLayer.locations = [0.001,1];
        if isH {
            gradientLayer.startPoint = CGPoint.init(x: 0, y: 0);
            gradientLayer.endPoint = CGPoint.init(x: 0, y: 1.0);
        }else{
            gradientLayer.startPoint = CGPoint.init(x: 0, y: 0);
            gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 0);
        }
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.bounds.size.height);
        self.layer.insertSublayer(gradientLayer, at: 0);
        
    }
    
    /**
     添加阴影
     
     @param color 阴影颜色
     @param alpha 透明度
     @param x 偏移值x
     @param y 偏移值y
     @param radius 阴影圆弧
     */
    func TOsetYinyingColor (color:UIColor,alpha:Float,x:CGFloat,y:CGFloat,radius:CGFloat) {
        self.layer.shadowColor = color.cgColor;//设置阴影的颜色
        self.layer.shadowOpacity = alpha;//设置阴影的透明度
        self.layer.shadowOffset = CGSize.init(width: x, height: y)//设置阴影的偏移量
        self.layer.shadowRadius = radius;//设置阴影的圆角
    }
    
    //让view左右晃动
    func TOworningShake() {
        let kfa = CAKeyframeAnimation.init(keyPath: "transform.translation.x")
        let s = 5;
        kfa.values = [-s,0,s,0,-s,0,s,0];
        kfa.duration = 0.2;
        kfa.repeatCount = 2;
        kfa.isRemovedOnCompletion = true;
        self.layer.add(kfa, forKey: "shake")
    }
}




// MARK: - 图片扩展
extension UIImage {
    //不被渲染图片
    class func TOimageWithNameOfOriger(name:String) -> UIImage {
        return UIImage(named:name)!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
    
    //    生成二维码
    class func TOscanCodeImage(str:String,size:CGFloat,centerImage:UIImage?) -> UIImage {
        let filter = CIFilter.init(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data = str.data(using: String.Encoding.utf8)
        filter?.setValue(data , forKeyPath: "inputMessage")
        var outimage = filter?.outputImage
        let transform = CGAffineTransform.init(scaleX: size, y: size)
        outimage = outimage?.transformed(by: transform)
        var resultImage = UIImage.init(ciImage: outimage!)
        resultImage = UIImage.init().TOgetNewImage(sourceImage: resultImage, center: centerImage)
        
        return resultImage
    }
    // 保证图片放大清晰的方法
    func TOgetNewImage(sourceImage: UIImage, center: UIImage?) -> UIImage {
        
        let size = sourceImage.size
        // 1. 开启图形上下文
        UIGraphicsBeginImageContext(size)
        // 2. 绘制大图片
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        // 3. 绘制小图片
        let width: CGFloat = 80
        let height: CGFloat = 80
        let x: CGFloat = (size.width - width) * 0.5
        let y: CGFloat = (size.height - height) * 0.5
        center?.draw(in: CGRect.init(x: x, y: y, width: width, height: height))
        // 4. 取出结果图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        // 5. 关闭上下文
        UIGraphicsEndImageContext()
        // 6. 返回结果
        return resultImage!
    }
    
    //     设置纯色背景的图片
    class func TOimageWithColor(color:UIColor) -> UIImage {
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image!
    }
    /**
     压缩图片
     
     @param sourceImage 要压缩的图片
     @param targetWidth 压缩宽度
     @return 压缩后的图片
     */
    func TOimageWithcompressImage(sourceImage:UIImage,targetWidth:CGFloat) -> UIImage {
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetHeight = (targetWidth/width)*height
        UIGraphicsBeginImageContext(CGSize.init(width: targetWidth, height: targetHeight))
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: targetWidth, height: targetHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
