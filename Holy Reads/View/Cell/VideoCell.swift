//
//  VideoCell.swift
//  Holy Reads
//
//  Created by mac-14 on 30/08/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoCell: UICollectionViewCell {
   
    @IBOutlet weak var VideoImgView: UIImageView!
    
    @IBOutlet weak var viewVideo: UIView!
    var avpController = AVPlayerViewController()
    var player = AVPlayer()
    
    
    
}
