

import UIKit

extension UILabel {
    
    convenience init(title: String,
                     fontSize: CGFloat = 14,
                     color: UIColor = UIColor.darkGray,
                     redundance: CGFloat = 0,
                     align: Bool) {
        
        self.init()
        
        text = title
        textColor = color
        font = UIFont.systemFont(ofSize: fontSize)
        numberOfLines = 0
        
        if redundance == 0 {
            textAlignment = .center
        } else {
            // 设置换行宽度
            preferredMaxLayoutWidth = UIScreen.main.bounds.width - redundance
            textAlignment = .center
        }
        
        sizeToFit()
    }
    
    /// 便利构造函数
    ///
    /// - parameter title:          title
    /// - parameter fontSize:       fontSize，默认 14 号字
    /// - parameter color:          color，默认深灰色
    /// - parameter redundance:     剪掉整个屏幕中多余的部分,默认为0，局中显示，如果设置，则左对齐
    ///
    /// - returns: UILabel
    /// 参数后面的值是参数的默认值，如果不传递，就使用默认值
    convenience init(title: String,
        fontSize: CGFloat = 14,
        color: UIColor = UIColor.darkGray,
        redundance: CGFloat = 0) {
            
        self.init()
        
            text = title
            textColor = color
            font = UIFont.systemFont(ofSize: fontSize)
            numberOfLines = 0
                
            if redundance == 0 {
                textAlignment = .center
            } else {
                // 设置换行宽度
                preferredMaxLayoutWidth = UIScreen.main.bounds.width - redundance
                textAlignment = .left
            }
            
            sizeToFit()
    }
}



