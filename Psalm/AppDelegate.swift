
 
 import UIKit
import AVFoundation
import MediaPlayer


var searchViewController = SearchViewController()
var playViewController = PlayViewController()
var selectedChapter = 0
var confirmedColl = Collected(collName:"", collArray:[])
var confirmedIndex = 0 //-1
var  chapter = 0
var selectedColl = Collected(collName:"", collArray:[])
var nowPlayingFirstLine = ""
var selectedIndex:Int = 0 {
  didSet {
    justBeforeSelectedIndex = oldValue
 //   print ( "the value of selectedIndex changed from \(oldValue) to \(selectedIndex)")
    // playViewController.playingInfo(selectedIndex: selectedIndex)
    
  }
}




var justBeforeSelectedIndex: Int = 0


var nowPlaying = false {
  didSet {
    if audioPlayer != nil {
      nowPlaying = (audioPlayer?.isPlaying)!
     
    }
    
  }
  
}
var  audioPlayer: AVAudioPlayer? {
  get {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.audioPlayer
  }
  set {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.audioPlayer = newValue
  }
}

//let commandCenter = MPRemoteCommandCenter.shared()
  


@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
  
  var window: UIWindow?
  let tintColor =  UIColor(red: 242/255, green: 71/255, blue: 63/255, alpha: 1)
  var backgroundSessionCompletionHandler: (() -> Void)?
//  var  qplayer: AVQueuePlayer? = nil
  var audioPlayer: AVAudioPlayer? = nil
  var  noOfDownloadedTract = 0
  var searchResults: [Track] = []
  var queryService = QueryService()
  var searchViewController = SearchViewController()
  var playViewController = PlayViewController()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    searchResults = queryService.getSearchResults(coll: selectedColl)
    noOfDownloadedTract = searchViewController.checkDownloaded(results: searchResults)
     
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    var initialViewController = storyboard.instantiateViewController(withIdentifier: "firstNaviViewController")
    
    if noOfDownloadedTract == queryService.numberOfChapters {
      
       initialViewController = storyboard.instantiateViewController(withIdentifier: "secondNaviViewController")
      
      
      //      let splitViewController = window!.rootViewController as! UISplitViewController
//      let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
//      navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
//      splitViewController.preferredDisplayMode = .allVisible
//      splitViewController.delegate = self
      
      
    }
  
   customizeAppearance()
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = initialViewController
    self.window?.makeKeyAndVisible()
    customizeAppearance()
    return true
  }
  
  func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
    backgroundSessionCompletionHandler = completionHandler
  }

  // MARK - App Theme Customization
  
  private func customizeAppearance() {
    window?.tintColor = .red //tintColor
    UISearchBar.appearance().barTintColor = .white
    UISearchBar.appearance().backgroundColor = .clear //tintColor
    
    UINavigationBar.appearance().alpha = 0.8
 //   UINavigationBar.appearance().barTintColor = tintColor.withAlphaComponent(0.1)
    UINavigationBar.appearance().tintColor = UIColor.red
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):UIColor.red]
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
    
    
  }
  
  let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  func localFilePath(for url: URL) -> URL {
    return documentsPath.appendingPathComponent(url.lastPathComponent)
  }

//  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
//    guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
//   // guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
//   // if topAsDetailController.detailCandy == nil {
//      // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
////      return true
////    }
//    return false
//  }
//
  
  
  
 }
 
