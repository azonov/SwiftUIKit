//
//  BlockView.swift
//  SwiftUIKit
//
//  Created by Andrey Zonov on 13.12.2020.
//

import UIKit

public protocol BlockView: Block {
    
    func block(_ context: BlockContext) -> Block
    
    func build(_ block: Block, with context: BlockContext) -> UIView
    
}

extension BlockView {
    
    public func build(with context: BlockContext) -> UIView {
        return build(block(context), with: context)
    }
    
    public func build(_ Block: Block, with context: BlockContext) -> UIView {
        let view = Block.build(with: context)
        if let modifying = self as? BlockModifying {
            let context = modifying.modifiers.modified(context, for: view)
            modifying.modifiers.apply(to: view, with: context)
        }
        return view
    }
    
}
