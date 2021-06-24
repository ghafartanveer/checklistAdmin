//
//  CompatibilityShims.swift
//  Pie Chart View
//
//  Created by Hamish Knight on 19/08/2018.
//  Copyright © 2018 Redonkulous Apps. All rights reserved.
//

import UIKit

#if !swift(>=4.2)
extension UIApplication {
  typealias LaunchOptionsKey = UIApplicationLaunchOptionsKey
}

extension NSAttributedString {
  typealias Key = NSAttributedStringKey
}
#endif
