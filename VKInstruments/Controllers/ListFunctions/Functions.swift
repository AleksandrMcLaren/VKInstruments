//
//  Functions.swift
//  VKInstruments
//
//  Created by Aleksandr on 05/07/2017.
//
//

import UIKit

enum FunctionType : String {
    
    case libriaryPhoto
    case libriaryVideo
    case cameraPhoto
    case cameraVideo
    case audioRecord
}

class Function {
    
    var type: FunctionType = .libriaryPhoto
    var title: String = ""
    var selected: Bool = false
    var fileUrl: URL?
}
