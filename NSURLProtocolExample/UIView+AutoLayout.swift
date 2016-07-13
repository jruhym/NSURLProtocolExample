//
//  UIView+AutoLayout.swift
//  NSURLProtocolExample
//
//  Created by Andrew Heim on 7/11/16.
//  Copyright © 2016 Zedenem. All rights reserved.
//

import UIKit

extension UIView {
    func pinView(subview: UIView) {
        addSubview(subview)

        addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
    }
}