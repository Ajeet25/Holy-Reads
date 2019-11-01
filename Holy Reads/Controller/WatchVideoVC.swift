//
//  WatchVideoVC.swift
//  Holy Reads
//
//  Created by mac-14 on 31/08/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class WatchVideoVC: UIViewController {
   
    // MARK: - IBOutlet
    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var btnPlayVideo: UIButton!
    @IBOutlet weak var viewVideo: UIView!
    // MARK: - Variable
    var avpController = AVPlayerViewController()
    var player = AVPlayer()
    var dictBookDetails = [String: Any]()
    
     // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view.
        
        viewVideo.layer.cornerRadius = 10
        viewVideo.layer.masksToBounds = true
        if let url = dictBookDetails["video"] as? String {
            let videoURL = URL(string: url)!
        
            
            self.player = AVPlayer(url: videoURL)
            self.avpController = AVPlayerViewController()
            self.avpController.player = self.player
            avpController.view.frame.size.width = viewVideo.frame.size.width
            avpController.view.frame.size.height = viewVideo.frame.size.height
            self.addChild(avpController)
            self.viewVideo.addSubview(avpController.view)
        }
        if(player.timeControlStatus == AVPlayer.TimeControlStatus.playing)
        {
            player.pause()
        }
        else if(player.timeControlStatus == AVPlayer.TimeControlStatus.paused)
        {
            player.play()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
      // MARK: - NavigationBar Buttons
    @IBAction func btnBack_DidSelect(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDownload_DidSelect(_ sender: Any) {
        
    }
    
    @IBAction func btnPlayVideo(_ sender: Any) {

    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
