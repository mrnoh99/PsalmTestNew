//
//  CollectedCell.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 4. 7..
//  Copyright © 2018년 Ray Wenderlich. All rights reserved.
//

import UIKit

class CollectedCell: UITableViewCell {

  @IBOutlet weak var test: UILabel!
  @IBOutlet weak var collArrayLabel: UILabel!
  @IBOutlet weak var collNameLabel: UILabel!
  
  func configure(collected: Collected) {
    if collected.collArray != []{
    var psalmText = "시편 제"
    for line in collected.collArray {
      psalmText = psalmText + String(line + 1) + ", "
   }
  collArrayLabel.text = psalmText + "편"
    }else {
      collArrayLabel.text = "" 
    }
      collNameLabel.text = collected.collName
  
    
    }
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
