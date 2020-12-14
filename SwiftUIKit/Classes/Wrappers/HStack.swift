//
//  HStackBlock.swift
//  SwiftUIKit
//
//  Created by Andrey Zonov on 13.12.2020.
//

import UIKit

public struct HStackBlock
: BlocksContaining
  , BlockViewModifying
  , BlockPadding
  , CustomDebugStringConvertible {
    
    public var debugDescription: String { "HStackBlock()" }
    
    public var blocks: [Block]
    public var modifiers = BlockModifiers()
    
    public init(_ blocks: [Block] = []) {
        self.blocks = blocks
    }
    
    public func build(with context: BlockContext) -> UIView {
        let stack = BlockPrivateStackView()
        let context = modifiers.modified(context, for: stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.insetsLayoutMarginsFromSafeArea = false
        stack.axis = .horizontal
        stack.spacing = UIStackView.spacingUseSystem
        
        if let insets = modifiers.padding {
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layoutMargins = insets
        }
        
        for block in blocks {
            stack.addArrangedSubview(block.build(with: context))
        }
        
        modifiers.apply(to: stack, with: context)
        
        return stack
    }
    
    public func alignment(_ alignment: UIStackView.Alignment) -> Self {
        return modified(BlockModifier(keyPath: \UIStackView.alignment, value: alignment))
    }
    
    public func distribution(_ distribution: UIStackView.Distribution) -> Self {
        return modified(BlockModifier(keyPath: \UIStackView.distribution, value: distribution))
    }
    
    public func placeholder(_ blocks: [Block]) -> Self {
        return modified { $0.blocks = blocks }
    }
    
    public func spacing(_ spacing: CGFloat) -> Self {
        return modified(BlockModifier(keyPath: \UIStackView.spacing, value: spacing))
    }
    
    public func with(_ block: @escaping BlockModifierBlockType<UIStackView>) -> Self {
        return modified(BlockModifierBlock(block))
    }
}

