//
//  ZStack.swift
//  SwiftUIKit
//
//  Created by Andrey Zonov on 14.12.2020.
//

import UIKit

public struct ZStackBlock
: BlocksContaining
  , BlockViewModifying
  , BlockPadding
  , CustomDebugStringConvertible {
    
    public var debugDescription: String { "ZStackBlock()" }
    
    public let blocks: [Block]
    public var modifiers = BlockModifiers()
    
    public init(_ blocks: [Block]) {
        self.blocks = blocks
    }
    
    public func build(with context: BlockContext) -> UIView {
        let view = UIView()
        let context = modifiers.modified(context, for: view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.insetsLayoutMarginsFromSafeArea = false
        view.backgroundColor = .clear
        
        for block in blocks {
            let subview = block.build(with: context)
            view.addConstrainedSubview(subview, with: modifiers.padding)
        }
        
        modifiers.apply(to: view, with: context)
        
        return view
    }
    
    public func with(_ block: @escaping BlockModifierBlockType<UIView>) -> Self {
        return modified(BlockModifierBlock(block))
    }
}
