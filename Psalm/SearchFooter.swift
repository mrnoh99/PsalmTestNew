

import UIKit

class SearchFooter: UIView {
  
  let label: UILabel = UILabel()
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
  }
  
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    configureView()
  }
  
  func configureView() {
    self.backgroundColor = UIColor.candyGreen
    self.alpha = 0.0
    
    // Configure label
    label.textAlignment = .center
    label.textColor = UIColor.white
    addSubview(label)
  }
  
  override func draw(_ rect: CGRect) {
    label.frame = self.bounds
  }
  
  //MARK: - Animation
  
  fileprivate func hideFooter() {
    UIView.animate(withDuration: 0.7) {[unowned self] in
      self.alpha = 0.0
    }
  }
  
  fileprivate func showFooter() {
    UIView.animate(withDuration: 0.7) {[unowned self] in
      self.alpha = 1.0
    }
  }
}

extension SearchFooter {
  //MARK: - Public API
  
  public func setNotFiltering() {
    label.text = ""
    hideFooter()
  }
  
  public func setIsFilteringToShow(filteredItemCount: Int, of totalItemCount: Int) {
    if (filteredItemCount == totalItemCount) {
      setNotFiltering()
    } else if (filteredItemCount == 0) {
      label.text = "찾으시는 시편이 없습니다 "
      showFooter()
    } else {
      label.text = "전체 "+"\(totalItemCount)장 중"+" \(filteredItemCount) 장 "
      showFooter()
    }
  }

}
