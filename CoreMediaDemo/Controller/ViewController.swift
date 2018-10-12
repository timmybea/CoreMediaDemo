//
//  ViewController.swift
//  CoreMediaDemo
//
//  Created by Tim Beals on 2018-10-12.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {

    lazy var button: UIButton = {
        let btn = UIButton(type: .roundedRect)
        btn.setTitle("Begin", for: .normal)
        btn.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var videoPlayerView: VideoPlayerView?
    
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.white
    }
    
    override func viewWillLayoutSubviews() {
        button.removeFromSuperview()
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])

    }
    
    @objc func buttonTapped(sender: UIButton) {
        switch sender.titleLabel?.text {
        case "Begin": self.launchOptions()
        case "Play Movie": self.playMovie()
        case "Close Player": self.closePlayer()
        default: print("Reached end of button switch")
        }
    }
    
    private func launchOptions() {
        UIAlertController.presentActionSheet(options: ["Video Recorder", "Cancel"], in: self) { (selection) in
            if selection == "Video Recorder" {
                VideoService.instance.launchVideoRecorder(in: self, completion: nil)
                VideoService.instance.delegate = self
            }
        }
    }

    private func playMovie() {
        
        guard let url = videoURL else { return }
        
        let playerRect = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width / 2)
        videoPlayerView = VideoPlayerView(withFrame: playerRect, videoURLString: url.path)
        view.addSubview(videoPlayerView!)
        button.setTitle("Close Player", for: .normal)
    }
    
    private func closePlayer() {
//        self.videoPlayerView
        self.videoPlayerView?.removeFromSuperview()
        self.videoPlayerView = nil
        button.setTitle("Begin", for: .normal)
    }
    
}

extension ViewController : VideoServiceDelegate {
    
    func videoDidFinishSaving(success: Bool, url: URL?) {
        
        if success {
            button.setTitle("Play Movie", for: .normal)
            self.videoURL = url
        }
        
        let title = success ? "Success" : "Error"
        let message = success ? "Video was saved" : "Could not save video"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
