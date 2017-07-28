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
        interactor.didSelectFunction(function)
    }
}

extension FunctionsPresenter : FunctionsInteractorOutput {
    
    func functionsFetched(_ functions: [Function]) {
        view?.showFunctionsData(functions)
    }
}
