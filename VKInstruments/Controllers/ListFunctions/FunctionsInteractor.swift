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
    func updateFunction(_ function: Function, fileUrl: URL?)
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
        photo.type = .libriaryPhoto
        photo.title = "yourPhoto".lcd
        photo.selected = false
        functions.append(photo)
        
        let video = Function()
        video.type = .libriaryVideo
        video.title = "yourVideo".lcd
        video.selected = false
        functions.append(video)

        let cameraVideo = Function()
        cameraVideo.type = .cameraVideo
        cameraVideo.title = "cameraVideo".lcd
        cameraVideo.selected = false
        functions.append(cameraVideo)
        
        let cameraPhoto = Function()
        cameraPhoto.type = .cameraPhoto
        cameraPhoto.title = "cameraPhoto".lcd
        cameraPhoto.selected = false
        functions.append(cameraPhoto)
        
        let audio = Function()
        audio.type = .audioRecord
        audio.title = "audioRecord".lcd
        audio.selected = false
        functions.append(audio)
    }

    func updateFunction(_ function: Function, fileUrl: URL?) {
        
        function.fileUrl = fileUrl
        
        let selected = (function.fileUrl != nil) ? true : false
        
        if selected != function.selected {
            function.selected = selected
            self.output.functionsFetched(self.functions)
        }
    }
}
