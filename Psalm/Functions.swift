

import Foundation
import UIKit

extension SearchViewController {
  
  func connectionAlert(title: String, message: String) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    
  }
}

extension PlayViewController {
  
  func connectionAlert(title: String, message: String) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  func reloadTable(){
    if selectedIndex != -1 {
    let nowPlayingIndexPath = IndexPath(item: selectedIndex, section: 0)
    self.playTableView.reloadData()
    self.playTableView.scrollToRow(at: nowPlayingIndexPath, at: .middle, animated: false)
    }
  }
    
    
}

