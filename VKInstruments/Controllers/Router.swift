//
//  Router.swift
//  VKInstruments
//
//  Created by Aleksandr on 05/07/2017.
//
//

import UIKit
import MLImagePicker

class Router: UIViewController {

    var currentController: UIViewController? = nil

    // MARK: - Life cycle

    static let shared: Router = Router()

    override func viewDidLoad() {
        
        super.viewDidLoad()

      //  navigationController?.navigationBar.clipsToBounds = true;
        
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

extension Router {
    
    func openFunctions() {
        
        let view = FunctionsViewController()
        let presenter = FunctionsPresenter()
        let interactor = FunctionsInteractor()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        
        interactor.output = presenter
        
        openViewController(presenter.view!)
        title = "Add"
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

    func presentImagePicker(completion: ((_ fileUrl: URL?) -> Void)?) {

     //   let imagePicker = ImagePicker()
     //   imagePicker.picker.sourceType = .camera
        
        MLImagePicker().presentInController(self, completion: { (fileUrl) in
            completion?(fileUrl)
        })
    }
}
