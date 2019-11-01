//
//  SlideCell.swift
//  Holy Reads
//
//  Created by mac-14 on 03/09/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit

class SlideCell: UICollectionViewCell {

    @IBOutlet weak var imgIntro: UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var imgSelectedPage: UIImageView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
