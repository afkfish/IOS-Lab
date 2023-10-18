//
//  UIImageExtension.swift
//  Messenger
//
//  Copyright © 2017. BME AUT. All rights reserved.
//

import UIKit

extension UIImage {

  func scale(to size: CGSize) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image(actions: { rendererContext in
      self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    })
  }

}
