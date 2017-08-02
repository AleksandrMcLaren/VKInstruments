//
//  FunctionsPresenter.swift
//  VKInstruments
//
//  Created by Aleksandr on 05/07/2017.
//
//

import UIKit

protocol FunctionsPresentation: class {
    
    func needsUpdateView()
    func didSelectFunction(_ function: Function)
    
    
}

protocol FunctionsInteractorOutput: class {
    
    func functionsFetched(_ functions: [Function])
}

class FunctionsPresenter: FunctionsPresentation {

    weak var view: FunctionsViewController?
    var interactor = FunctionsInteractor()

    func needsUpdateView() {
        interactor.fetchFunctions()
    }
    
    func didSelectFunction(_ function: Function) {
        actionFunction(function)
    }
    
    func actionFunction(_ function: Function) {
        
        switch function.type {
            
        case .audioRecord:
            openAudioRecordsFunction(function)
            break
            
        case .libriaryPhoto:
            openLibriaryPhotoFunction(function)
            break
            
        case .libriaryVideo:
            openLibriaryVideoFunction(function)
            break
            
        case .cameraPhoto:
            openCameraPhotoFunction(function)
            break
            
        case .cameraVideo:
            openCameraVideoFunction(function)
            break
        }
    }
    
    func openAudioRecordsFunction(_ function: Function) {
        
        Router.shared.presentAudioRecords(fileUrl: function.fileUrl,  completion: { (fileUrl) in
            self.interactor.updateFunction(function, fileUrl: fileUrl)
        })
    }
    
    func openLibriaryPhotoFunction(_ function: Function) {
        
        Router.shared.presentLibriaryPhotoPicker(completion: { (fileUrl) in
            self.interactor.updateFunction(function, fileUrl: fileUrl)
        })
    }
    
    func openLibriaryVideoFunction(_ function: Function) {
        
        Router.shared.presentLibriaryVideoPicker(completion: { (fileUrl) in
            self.interactor.updateFunction(function, fileUrl: fileUrl)
        })
    }
    
    func openCameraPhotoFunction(_ function: Function) {
        
        Router.shared.presentCameraPhotoPicker(completion: { (fileUrl) in
            self.interactor.updateFunction(function, fileUrl: fileUrl)
        })
    }
    
    func openCameraVideoFunction(_ function: Function) {
        
        Router.shared.presentCameraVideoPicker(completion: { (fileUrl) in
            self.interactor.updateFunction(function, fileUrl: fileUrl)
        })
    }
}

extension FunctionsPresenter : FunctionsInteractorOutput {
    
    func functionsFetched(_ functions: [Function]) {
        view?.showFunctionsData(functions)
    }
}
