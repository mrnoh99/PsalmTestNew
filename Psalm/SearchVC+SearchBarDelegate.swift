

import Foundation
import UIKit

extension SearchViewController: UISearchBarDelegate {

//  @objc func dismissKeyboard() {
//    searchBar.resignFirstResponder()
//  }
  
//  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//    dismissKeyboard()
//      UIApplication.shared.isNetworkActivityIndicatorVisible = true
//      self.searchResults = queryService.getSearchResults()
//          self.tableView.reloadData()
//          self.tableView.setContentOffset(CGPoint.zero, animated: false)
//
//  }
  
 
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
  
  func connectionAlert(title: String, message: String) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    
  }
}
