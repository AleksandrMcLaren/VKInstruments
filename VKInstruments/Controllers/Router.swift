//
//  Router.swift
//  VKInstruments
//
//  Created by Aleksandr on 05/07/2017.
//
//

import UIKit
import MLImagePicker

protocol RouterNavigations {
    
    func openFunctions()
    func presentAudioRecords(fileUrl: URL?, completion: ((_ fileUrl: URL?) -> Void)?)
    func presentLibriaryPhotoPicker(completion: ((_ fileUrl: URL?) -> Void)?)
    func presentLibriaryVideoPicker(completion: ((_ fileUrl: URL?) -> Void)?)
    func presentCameraPhotoPicker(completion: ((_ fileUrl: URL?) -> Void)?)
    func presentCameraVideoPicker(completion: ((_ fileUrl: URL?) -> Void)?)
}

class Router: UIViewController {

    var currentController: UIViewController? = nil

    // MARK: - Life cycle

    static let shared: Router = Router()

    override func viewDidLoad() {
        
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
    
        let boundsSize = view.bounds.size
        currentController?.view.frame = CGRect(x: 0, y: 0, width: boundsSize.width, height: boundsSize.height)
    }
    
    // MARK: - NavigationBar
    
    func showNavigationBar() {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func hideNavigationBar() {
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Navigation methods

    func openViewController(_ vc: UIViewController) {
        
        currentController = vc
        view.addSubview((currentController?.view)!)
        view.setNeedsLayout()
    }
    
    func pushViewController(_ vc: UIViewController) {
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentViewController(_ vc: UIViewController) {
        
        navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension Router: RouterNavigations {
    
    func openFunctions() {
        
        let view = FunctionsViewController()
        let presenter = FunctionsPresenter()
        let interactor = FunctionsInteractor()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        
        interactor.output = presenter
        
        openViewController(presenter.view!)
        title = "add".lcd
    }
    
    func presentAudioRecords(fileUrl: URL?, completion: ((_ fileUrl: URL?) -> Void)?) {
         
        let view = AudioViewController()
        let presenter = AudioPresenter()
        let interactor = AudioInteractor()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        
        interactor.output = presenter

        presenter.fileUrl = fileUrl
        presenter.completion = { (fileUrl) -> Void in
            completion?(fileUrl)
        }

        presentViewController(presenter.view!)
    }

    func presentLibriaryPhotoPicker(completion: ((_ fileUrl: URL?) -> Void)?) {

        let imagePicker = MLImagePicker()
        imagePicker.picker.mediaTypes = ["public.image"];
        
        imagePicker.presentInController(self, completion: { (fileUrl) in
            completion?(fileUrl)
        })
    }
    
    func presentLibriaryVideoPicker(completion: ((_ fileUrl: URL?) -> Void)?) {
        
        let imagePicker = MLImagePicker()
        imagePicker.picker.mediaTypes = ["public.movie"];
        
        imagePicker.presentInController(self, completion: { (fileUrl) in
            completion?(fileUrl)
        })
    }
    
    func presentCameraPhotoPicker(completion: ((_ fileUrl: URL?) -> Void)?) {
        
        let imagePicker = MLImagePicker()
        imagePicker.picker.sourceType = .camera
        imagePicker.picker.mediaTypes = ["public.image"];
        
        imagePicker.presentInController(self, completion: { (fileUrl) in
            completion?(fileUrl)
        })
    }
    
    func presentCameraVideoPicker(completion: ((_ fileUrl: URL?) -> Void)?) {
        
        let imagePicker = MLImagePicker()
        imagePicker.picker.sourceType = .camera
        imagePicker.picker.mediaTypes = ["public.movie"];
        
        imagePicker.presentInController(self, completion: { (fileUrl) in
            completion?(fileUrl)
        })
    }
}
