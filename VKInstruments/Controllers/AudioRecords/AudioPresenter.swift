//
//  AudioPresenter.swift
//  VKInstruments
//
//  Created by Aleksandr on 25/07/2017.
//
//

import UIKit

protocol AudioPresentation: class {
    
    func needsUpdateView()
    
    func startRecordPressed()
    func stopRecordPressed()
    func playPressed()
    func resetPressed()
    func donePressed()
}

protocol AudioInteractorOutput: class {
    
    func updatedData(_ data: AudioModel)
}

class AudioPresenter: AudioPresentation {

    weak var view: AudioViewController?
    var interactor = AudioInteractor()
    
    var completion : ((_ fileUrl: URL?) -> Void)?
    var fileUrl: URL? {
        didSet {
            configureAudioRecorder()
        }
    }
    
    fileprivate var timer: Timer?
    fileprivate let audioRecorder = MLAudioRecorder()
    
    deinit {
        print(" ")
    }

    @objc func needsUpdateView() {
        
        interactor.currentTime = audioRecorder.currentTime
        interactor.fetchData()
    }
    
    func configureAudioRecorder () {

        audioRecorder.fileUrl = fileUrl
    
        audioRecorder.finishRecording = { [weak self] (fileUrl, success) -> Void in
            
            self?.timerStop()
            
            if success == true {
                self?.fileUrl = fileUrl
            } else {
                self?.fileUrl = nil
            }
            
            self?.needsUpdateView()
        }
        
        audioRecorder.finishPlaying = { [weak self] () -> Void in
            
            self?.timerStop()
            self?.needsUpdateView()
        }
        
        audioRecorder.noAccessRecordPermission = { [weak self] () -> Void in
            
            let alertView = UIAlertController(title: "Message", message: "This app does not have access to your microphone. You can enable access in Privacy Settings", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler:nil)
            alertView.addAction(action)
            self?.view?.present(alertView, animated: true, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    func startRecordPressed () {
    
        stopActions()
        fileUrl = nil
        needsUpdateView()
        
        audioRecorder.startRecording(completion: { [weak self] (success) in
            
            if success == true {
                self?.timerStart()
            }
        })
    }
    
    func stopRecordPressed() {
    
        audioRecorder.stopRecording()
    }
    
    func playPressed() {
        
        audioRecorder.play()
        timerStart()
    }
    
    func resetPressed() {
        
        timerStop()
        audioRecorder.reset()
        fileUrl = nil
        needsUpdateView()
    }
    
    func stopActions () {
        
        timerStop()
        audioRecorder.stopRecording()
        audioRecorder.stop()
    }
    
    func donePressed() {
        
        stopActions();
        
        view?.dismiss(animated: true) {
            
            self.completion?(self.fileUrl)
        }
    }
    
    // MARK: - Timer
    
    func timerStart () {
        
        if timer != nil {
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.01,
                                     target: self,
                                     selector: #selector(AudioPresenter.needsUpdateView),
                                     userInfo: nil,
                                     repeats: true)
        timer?.fire()
    }
    
    func timerStop () {
        
        timer?.invalidate()
        timer = nil
    }
}

extension AudioPresenter : AudioInteractorOutput {
    
    func updatedData(_ data: AudioModel) {
        
        view?.updateData(data)
    }
}
