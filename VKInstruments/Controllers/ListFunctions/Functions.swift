//
//  Functions.swift
//  VKInstruments
//
//  Created by Aleksandr on 05/07/2017.
//
//

import UIKit

enum FunctionType : String {
    
    case photo
    case audioRecord
}

class Function {
    
    var type: FunctionType = .photo
    var title: String = ""
    var selected: Bool = false
    var fileUrl: URL?
}
