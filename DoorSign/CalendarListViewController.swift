//
//  CalendarListViewController.swift
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 9/10/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

import UIKit

extension NSBundle {
  
  func infoDictionaryStringForKey(key: String) -> String? {
    return self.infoDictionary?[key] as? String
  }
  
}

class CalendarListViewController: UIViewController {

  @IBOutlet weak var versionStringDisplay: UILabel!

  override func prefersStatusBarHidden() -> Bool {
    return false
  }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  override func viewDidLoad() {
    let bundle = NSBundle.mainBundle()
    let name = bundle.infoDictionaryStringForKey("CFBundleName") ?? ""
    let version = bundle.infoDictionaryStringForKey("CFBundleShortVersionString") ?? ""
    let build = bundle.infoDictionaryStringForKey("CFBundleVersion") ?? ""
    
    self.versionStringDisplay.text = "\(name) v\(version) (\(build))"
  }
  
}
