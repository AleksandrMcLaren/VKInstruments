//
//  FunctionsInteractor.swift
//  VKInstruments
//
//  Created by Aleksandr on 05/07/2017.
//
//

import UIKit

protocol FunctionsUseCase: class {
    
    func fetchFunctions()
    func didSelectFunction(_ function: Function)
}

class FunctionsInteractor: FunctionsUseCase {

    weak var output: FunctionsInteractorOutput!
    var functions: [Function] = []

    func fetchFunctions() {
        
        if functions.count == 0 {
            createFunctions()
        }
        
        output.functionsFetched(functions)
    }
    
    func createFunctions () {
        
        let photo = Function()
        photo.type = .photo
        photo.title = "Photo"
        photo.selected = false
        functions.append(photo)
        
        let audio = Function()
        audio.type = .audioRecord
        audio.title = "Audio record"
        audio.selected = false
        functions.append(audio)
    }
    
    func didSelectFunction(_ function: Function) {

        actionFunction(function)
    }
    
    func actionFunction(_ function: Function) {
     
        switch function.type {
     
            case .audioRecord:
                openAudioRecordsFunction(function)
            break
            
            case .photo:
                openImageFunction(function)
            break
        }
    }
    
    func openAudioRecordsFunction(_ function: Function) {
        
        Router.shared.presentAudioRecords(fileUrl: function.fileUrl,  completion: { (fileUrl) in
            
            function.fileUrl = fileUrl

            let selected = (function.fileUrl != nil) ? true : false
            
            if selected != function.selected {
                function.selected = selected
                self.output.functionsFetched(self.functions)
            }
        })
    }
    
    func openImageFunction(_ function: Function) {
        
        Router.shared.presentImagePicker(completion: { (fileUrl) in
            
            function.fileUrl = fileUrl
            
            let selected = (function.fileUrl != nil) ? true : false
            
            if selected != function.selected {
                function.selected = selected
                self.output.functionsFetched(self.functions)
            }
        })
    }
}
