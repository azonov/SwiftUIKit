//
//  ButtonBlock.swift
//  SwiftUIKit
//
//  Created by Andrey Zonov on 16.12.2020.
//

import UIKit


public struct ButtonBlock
: BlockViewModifying
  , BlockPadding
  , CustomDebugStringConvertible {
    
    public var debugDescription: String { "ButtonBlock()" }
    
    public var modifiers = BlockModifiers()
    
    public init(_ text: String? = nil, for state: UIControl.State = .normal) {
        if let text = text {
            modifiers.binding = BlockModifierBlock<UIButton> { button, _ in
                button.setTitle(text, for: state)
            }
        }
    }
    
    public func build(with context: BlockContext) -> UIView {
        
        let button = UIButton()
        let context = modifiers.modified(context, for: button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = context.theme.font.body
        button.setTitleColor(context.theme.color.link, for: .normal)
        button.contentEdgeInsets = modifiers.padding ?? button.contentEdgeInsets
        button.backgroundColor = .clear
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        modifiers.apply(to: button, with: context)
        
        return button
    }
    
    public func alignment(_ alignment: UIControl.ContentHorizontalAlignment) -> Self {
        return modified(BlockModifier(keyPath: \UIButton.contentHorizontalAlignment, value: alignment))
    }
    
    public func color(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        return modified(BlockModifierBlock<UIButton> { button, _ in
            button.setTitleColor(color, for: state)
        })
    }
    
    public func font(_ font: UIFont) -> Self {
        return modified(BlockModifierBlock<UIButton> { button, _ in
            button.titleLabel?.font = font
        })
    }
    
    public func text(_ text: String?, for state: UIControl.State = .normal) -> Self {
        return modified(BlockModifierBlock<UIButton> { button, _ in
            button.setTitle(text, for: state)
        })
    }
    
    public func with(_ block: @escaping BlockModifierBlockType<UIButton>) -> Self {
        return modified(BlockModifierBlock(block))
    }
}
