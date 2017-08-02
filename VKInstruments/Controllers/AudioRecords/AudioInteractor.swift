//
//  AudioInteractor.swift
//  VKInstruments
//
//  Created by Aleksandr on 25/07/2017.
//
//

import UIKit

protocol AudioUseCase: class {
    
    func fetchData()
}

class AudioInteractor: AudioUseCase {

    weak var output: AudioInteractorOutput!
    var recordedTime : TimeInterval = 0
    
    fileprivate let data: AudioModel = AudioModel()
    
    deinit {
        print(" ")
    }
    
    func fetchData() {
        
        configureData()
        output.updatedData(data)
    }

    func configureData () {

        var buttonsEnabled: Bool = false
        
        var minutes: Int = 0
        var seconds: Int = 0
        var ms: Int = 0
        
        if recordedTime != 0 {
            
            buttonsEnabled = true
            
            minutes = Int(recordedTime) / 60 % 60
            seconds = Int(recordedTime) % 60
            ms = Int((recordedTime.truncatingRemainder(dividingBy: 1)) * 100)
        }

        data.buttonsEnabled = buttonsEnabled
        data.time = String.init(format: "%0.2d:%0.2d:%0.2d", minutes, seconds, ms)
    }
}
