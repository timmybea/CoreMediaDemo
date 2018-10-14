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

    lazy var button: CustomButton = {
        let btn = CustomButton(type: .roundedRect)
        btn.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var videoPlayerView: VideoPlayerView?
    
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @objc func buttonTapped(sender: CustomButton) {
        switch sender.option {
        case .begin: self.launchOptions()
        case .playMovie: self.playMovie()
        case .closeMovie: self.closePlayer()
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
        button.option = .closeMovie
    }
    
    private func closePlayer() {
        self.videoPlayerView?.removeFromSuperview()
        self.videoPlayerView = nil
        button.option = .begin
    }
    
}

extension ViewController : VideoServiceDelegate {
    
    func videoDidFinishSaving(error: Error?, url: URL?) {
        let success: Bool = error == nil
        
        if success {
            button.option = .playMovie
            self.videoURL = url
        }
        
        let title = success ? "Success" : "Error"
        let message = success ? "Video was saved" : "Could not save video"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
        

}
