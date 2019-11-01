//
//  PlanCell.swift
//  Holy Reads
//
//  Created by mac-14 on 30/08/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit

class PlanCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
