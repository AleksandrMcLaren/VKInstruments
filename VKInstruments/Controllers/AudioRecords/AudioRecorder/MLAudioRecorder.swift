//
//  AudioRecorder.swift
//  VKInstruments
//
//  Created by Aleksandr on 07/07/2017.
//
//

import AVFoundation

open class MLAudioRecorder {

    open var finishRecording: ((_ fileUrl: URL?, _ success: Bool) -> Void)?
    open var finishPlaying: (() -> Void)?
    open var noAccessRecordPermission: (() -> Void)?
    open var fileUrl: URL? {
        didSet {
            self.configureAudioPlayer()
        }
    }
    
    fileprivate var _currentTime: TimeInterval = 0
    open var currentTime : TimeInterval {
        
        get {
            
            if audioRecorder?.isRecording == true {
                _currentTime = audioRecorder!.currentTime
            } else if audioPlayer?.isPlaying == true {
                _currentTime = audioPlayer!.currentTime
            } else if let _ = fileUrl, let audioPlayer = audioPlayer {
                _currentTime = audioPlayer.duration
            }
            
            return _currentTime
        }
        
        set {
            _currentTime = newValue
        }
    }
    
    fileprivate let recordingSession = AVAudioSession.sharedInstance()
    
    fileprivate var audioRecorder: AVAudioRecorder?
    fileprivate lazy var audioRecorderDelegate: MLAudioRecorderDelegate = {
    
        let _audioRecorderDelegate = MLAudioRecorderDelegate()
        _audioRecorderDelegate.completion = { [weak self] (recorder, success) in
    
            if success == true {
    
                DispatchQueue(label: "AudioRecorder.audioRecorderDidFinishRecording").sync {
    
                    if let filePath = LameConverter.convertFromWav(toMp3: recorder.url.path) {
    
                        let mp3FileUrl = URL.init(fileURLWithPath: filePath)
    
                        DispatchQueue.main.async {
                            self?.fileUrl = mp3FileUrl
                            self?.finishRecording?(mp3FileUrl, true)
                        }
    
                    } else {
                        
                        self?.reset()
                    }
                }
    
            } else {
    
                self?.reset()
            }
        }
        
        return _audioRecorderDelegate
    }()
    
    fileprivate var audioPlayer: AVAudioPlayer?
    fileprivate lazy var audioPlayerDelegate: MLAudioPlayerDelegate = {
        
        let _audioPlayerDelegate = MLAudioPlayerDelegate()
        _audioPlayerDelegate.completion = { [weak self] (player, success) in
            
            DispatchQueue.main.async {
                self?.finishPlaying?()
            }
        }
        
        return _audioPlayerDelegate
    }()

    public init () {
        
        requestRecordPermission()
    }
    
    deinit {
        
    }
    
    // MARK: - Control
    
    open func startRecording (completion: ((Bool) -> Void)?) {
        
        if recordingSession.recordPermission() != .granted {
            
            requestRecordPermission()
            return
        }
        
        if let audioRecorder = audioRecorder {
            
            audioRecorder.record()
            completion?(true)
            
        } else {
            
            completion?(false)
        }
    }
    
    open func stopRecording () {
        
        if audioRecorder?.isRecording == true {
            audioRecorder!.stop()
        }
    }
    
    open func play () {
        
        audioPlayer?.play()
    }
    
    open func stop () {
        
        if audioPlayer?.isPlaying == true {
            audioPlayer!.stop()
        }
    }
    
    open func reset () {
        
        currentTime = 0
        fileUrl = nil
    }
    
    // MARK: - Configure audio

    fileprivate func configureAudioPlayer() {
        
        do {
            
            audioPlayer = nil
            
            if let fileUrl = fileUrl {
                
                audioPlayer = try AVAudioPlayer(contentsOf: fileUrl)
                audioPlayer?.delegate = audioPlayerDelegate
                audioPlayer?.prepareToPlay()
            }
            
        } catch {
            
        }
    }

    fileprivate func createRecorder () {
        
        let settings = [
            // wav format
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMIsNonInterleaved: false,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey: 44100
            ] as [String : Any]
        
        let audioFileUrl = URL.init(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("vcirecording.wav")
        
        do {

            audioRecorder = try AVAudioRecorder(url: audioFileUrl, settings: settings)
            audioRecorder?.delegate = audioRecorderDelegate
            audioRecorder?.prepareToRecord()
            
        } catch {
            
        }
    }
    
    fileprivate func requestRecordPermission () {

        do {
            try! recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with:.defaultToSpeaker)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { allowed in
                
                if allowed == true {
                    
                    self.createRecorder()
                    
                } else {
                    
                    DispatchQueue.main.async {
                        self.noAccessRecordPermission?()
                    }
                }
            }
        } catch {
            
            DispatchQueue.main.async {
                self.noAccessRecordPermission?()
            }
        }
    }
}

// MARK: - Delegates

fileprivate class MLAudioRecorderDelegate: NSObject, AVAudioRecorderDelegate {

    var completion: ((_ recorder: AVAudioRecorder, _ success: Bool) -> Void)?
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        completion?(recorder, flag)
    }
}

fileprivate class MLAudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    
    var completion: ((_ player: AVAudioPlayer, _ success: Bool) -> Void)?
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        completion?(player, flag)
    }
}
