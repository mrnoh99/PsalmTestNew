
 
 import UIKit
import AVFoundation
 var searchViewController = SearchViewController()

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let tintColor =  UIColor(red: 242/255, green: 71/255, blue: 63/255, alpha: 1)
  var backgroundSessionCompletionHandler: (() -> Void)?
  var  qplayer: AVQueuePlayer? = nil
  var  noOfDownloadedTract = 0
  var searchResults: [Track] = []
  var queryService = QueryService()
  var searchViewController = SearchViewController()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    searchResults = queryService.getSearchResults()
    noOfDownloadedTract = searchViewController.checkDownloaded(results: searchResults)
    print (noOfDownloadedTract)
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    var initialViewController = storyboard.instantiateViewController(withIdentifier: "firstNaviViewController")
    
    if noOfDownloadedTract == queryService.numberOfChapters {
      
       initialViewController = storyboard.instantiateViewController(withIdentifier: "secondNaviViewController")
    }
    print(noOfDownloadedTract)
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
    window?.tintColor = tintColor
    UISearchBar.appearance().barTintColor = tintColor
    UINavigationBar.appearance().barTintColor = tintColor
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):UIColor.white]
  }
  let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  func localFilePath(for url: URL) -> URL {
    return documentsPath.appendingPathComponent(url.lastPathComponent)
  }

 }
 
