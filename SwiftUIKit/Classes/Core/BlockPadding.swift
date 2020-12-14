//
//  BlockPadding.swift
//  SwiftUIKit
//
//  Created by Andrey Zonov on 13.12.2020.
//

import UIKit

public protocol BlockPadding: BlockModifying {}

extension BlockPadding {
    
    public func padding(insets: UIEdgeInsets) -> Self {
        var Block = self
        Block.modifiers.padding = insets
        return Block
    }
    
    public func padding(_ padding: CGFloat) -> Self {
        return self.padding(insets: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }
    
    public func padding(h: CGFloat, v: CGFloat) -> Self {
        return self.padding(insets: UIEdgeInsets(top: v, left: h, bottom: v, right: h))
    }
    
    public func padding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        return self.padding(insets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
    
}
