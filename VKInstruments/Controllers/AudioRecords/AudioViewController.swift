//
//  AudioViewController.swift
//  VKInstruments
//
//  Created by Aleksandr on 06/07/2017.
//
//

import UIKit

protocol AudioView  {
    
    func updateData(_ data: AudioModel)
}

class AudioViewController: UIViewController {

    var presenter: AudioPresentation!
    
    fileprivate var data = AudioModel() {
        didSet {
            self.reloadData()
        }
    }

    fileprivate let timeLabel = UILabel()
    fileprivate let doneButton = UIButton()
    fileprivate let playButton = UIButton()
    fileprivate let resetButton = UIButton()
    fileprivate let recordButton = UIButton()
    fileprivate let roundView = UIView()
    
    // MARK: - Life cycle
    
    deinit {
        print(" ")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        view.backgroundColor = .white

        timeLabel.font = UIFont.systemFont(ofSize: 50)
        view.addSubview(timeLabel)
        
        let color = UIColor(red:0.97, green:0.10, blue:0.07, alpha:1.00)

        playButton.setTitle("Play", for: .normal)
        playButton.setTitleColor(color, for: .normal)
        playButton.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
        playButton.isExclusiveTouch = true;
        view.addSubview(playButton)
        
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(color, for: .normal)
        resetButton.addTarget(self, action: #selector(resetPressed), for: .touchUpInside)
        resetButton.isExclusiveTouch = true;
        view.addSubview(resetButton)
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(color, for: .normal)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        doneButton.isExclusiveTouch = true;
        view.addSubview(doneButton)
        
        recordButton.backgroundColor = .red
        recordButton.layer.masksToBounds = true
        recordButton.isExclusiveTouch = true;
        view.addSubview(recordButton)

        roundView.backgroundColor = .red
        roundView.layer.borderColor = UIColor.white.cgColor
        roundView.layer.borderWidth = 1
        recordButton.addSubview(roundView)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressing(_:)))
        recordButton.addGestureRecognizer(longPress)

        presenter.needsUpdateView()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let boundsSize = view.bounds.size
        
        let timeSize = timeLabel.textSize()
        let timeX = (boundsSize.width - timeSize.width) / 2
        timeLabel.frame = CGRect(x: timeX, y: 50, width: boundsSize.width - timeX, height: timeLabel.font.lineHeight)
        
        let buttonHeight: CGFloat = 60.0
        let doneWidth = doneButton.titleLabel?.textSize().width
        doneButton.frame = CGRect(x: (boundsSize.width - doneWidth!) / 2, y: boundsSize.height - buttonHeight, width: doneWidth!, height: buttonHeight)
        
        let recordWidth: CGFloat = 100.0
        recordButton.frame = CGRect(x: (boundsSize.width - recordWidth) / 2, y: boundsSize.height - buttonHeight - 40 - recordWidth, width: recordWidth, height: recordWidth)
        recordButton.layer.cornerRadius = recordButton.frame.size.width / 2
        
        let indent: CGFloat = 5.0
        roundView.frame = CGRect(x: indent, y: indent, width: recordWidth - indent * 2, height: recordWidth - indent * 2)
        roundView.layer.cornerRadius = roundView.frame.size.width / 2
        
        let resetWidth = resetButton.titleLabel?.textSize().width
        resetButton.frame = CGRect(x: 30, y: recordButton.frame.origin.y - 20 - buttonHeight, width: resetWidth!, height: buttonHeight)
        
        let playWidth = playButton.titleLabel?.textSize().width
        playButton.frame = CGRect(x: boundsSize.width - 30 - playWidth!, y: resetButton.frame.origin.y, width: playWidth!, height: buttonHeight)
    }
    
    // MARK: - Data
    
    func reloadData () {
        
        if resetButton.isEnabled != data.buttonsEnabled {
            
            resetButton.isEnabled = data.buttonsEnabled
            playButton.isEnabled = data.buttonsEnabled
            
            let alpha: CGFloat = (data.buttonsEnabled == true) ? 1.0 : 0.4
            playButton.titleLabel?.alpha = alpha
            resetButton.titleLabel?.alpha = alpha
        }
        
        timeLabel.text = data.time
    }
    
    // MARK: - Actions

    func longPressing(_ gesture: UILongPressGestureRecognizer) {
       
        if gesture.state == .began {
            presenter.startRecordPressed()
        } else if gesture.state == .ended {
            presenter.stopRecordPressed()
        }
    }
    
    func playPressed () {
        
        presenter.playPressed()
    }
    
    func resetPressed () {
        
        presenter.resetPressed()
    }
    
    func donePressed () {
        
        presenter.donePressed()
    }
}

extension AudioViewController: AudioView {
    
    func updateData(_ data: AudioModel) {
        
        self.data = data
    }
}
