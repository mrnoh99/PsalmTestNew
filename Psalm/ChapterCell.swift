//
//  ChapterCell.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 3. 29..
//  Copyright © 2018년 Ray Wenderlich. All rights reserved.
//

import UIKit

class ChapterCell: UITableViewCell {

  @IBOutlet weak var chapterLabel: UILabel!
  
   
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     chapterLabel.text = "test"
    
    
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
