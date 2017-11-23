//
//  AppLib.swift
//  VKInstruments
//
//  Created by Aleksandr on 07/07/2017.
//
//

import UIKit

extension UILabel {

    func textSize () -> CGSize {
        
        let string: NSString = ((text != nil) ? text! as NSString : "")
       
        let size = string.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude),
                                       options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                       attributes: [NSAttributedStringKey.font: font],
                                       context: nil).size
        
        return size
    }
}

extension String {
    
    var lcd: String {
        return NSLocalizedString(self, comment: "")
    }
}
