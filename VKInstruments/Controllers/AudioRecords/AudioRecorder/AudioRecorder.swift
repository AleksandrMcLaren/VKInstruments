//
//  AudioRecorder.swift
//  VKInstruments
//
//  Created by Aleksandr on 07/07/2017.
//
//

import AVFoundation

open class AudioRecorder: NSObject {

    open var finishRecording: ((_ fileUrl: URL?, _ success: Bool) -> Void)?
    open var finishPlaying: (() -> Void)?
    open var noAccessRecordPermission: (() -> Void)?
    open var fileUrl: URL? {
        didSet {
            self.audioPlayerConfigure(fileUrl)
        }
    }
    
    fileprivate var _recordedTime: TimeInterval = 0
    open var recordedTime : TimeInterval {
        
        get {
            
            if audioRecorder?.isRecording == true {
                _recordedTime = audioRecorder!.currentTime
            } else if audioPlayer?.isPlaying == true {
                _recordedTime = audioPlayer!.currentTime
            } else if fileUrl != nil && audioPlayer != nil {
                 _recordedTime = audioPlayer!.duration
            }
            
            return _recordedTime
        }
        
        set {
            _recordedTime = newValue
        }
    }
    
    fileprivate var recordingSession: AVAudioSession!
    fileprivate var audioRecorder: AVAudioRecorder?
    fileprivate var audioPlayer: AVAudioPlayer?

    public override init () {

        super.init()
        
        requestRecordPermission()
    }
    
    // MARK: - Control
    
    open func startRecording (completion: ((Bool) -> Void)?) {
        
        if recordingSession.recordPermission() != .granted {
            
            requestRecordPermission()
            return
        }
        
        if audioRecorder != nil {
            
            audioRecorder?.record()
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
        
        recordedTime = 0
        audioPlayerConfigure(nil)
    }
    
    // MARK: - Configure audio

    fileprivate func audioPlayerConfigure(_ fileUrl: URL?) {
        
        do {
            
            audioPlayer = nil
            
            if fileUrl != nil {
                
                audioPlayer = try AVAudioPlayer(contentsOf: fileUrl!)
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
            }
            
        } catch {
            
        }
    }
    
    fileprivate func requestRecordPermission () {

        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try! recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with:.defaultToSpeaker)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                
                if !allowed {
                    
                    DispatchQueue.main.async {
                        self.noAccessRecordPermission?()
                    }
                    
                } else {
                    
                    self.createRecorder()
                }
            }
        } catch {
            
            DispatchQueue.main.async {
                self.noAccessRecordPermission?()
            }
        }
    }
    
    fileprivate func createRecorder () {
        
        let settings = [
            // wav
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
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
            
        } catch {
            
        }
    }
}

extension AudioRecorder: AVAudioRecorderDelegate {

    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

        if flag == true {

            DispatchQueue(label: "AudioRecorder.audioRecorderDidFinishRecording").sync {

                if let filePath = LameConverter.convertFromWav(toMp3: recorder.url.path) {

                    let mp3FileUrl = URL.init(fileURLWithPath: filePath)
                    self.audioPlayerConfigure(mp3FileUrl)
                    
                    DispatchQueue.main.async {
                        self.finishRecording?(mp3FileUrl, true)
                    }
                    
                } else {
                    
                    self.reset()
                }
            }
            
        } else {
           
            self.reset()
        }
    }
}

extension AudioRecorder: AVAudioPlayerDelegate {
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        DispatchQueue.main.async {
            self.finishPlaying?()
        }
    }
}
