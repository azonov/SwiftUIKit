//
//  Label.swift
//  SwiftUIKit
//
//  Created by Andrey Zonov on 13.12.2020.
//

import UIKit

public struct LabelBlock
: BlockViewModifying
  , BlockPadding
  , CustomDebugStringConvertible {
    
    public var debugDescription: String { "LabelBlock()" }
    
    public var modifiers = BlockModifiers()
    public weak var underlyingView: UILabel?
    public init(_ text: String? = nil) {
        handle(newValue: text)
    }
    
    public func build(with context: BlockContext) -> UIView {
        let label = BlockLabel()
        let context = modifiers.modified(context, for: label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = context.theme.font.body
        label.textColor = context.theme.color.text
        label.textInsets = modifiers.padding
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        modifiers.apply(to: label, with: context)
        
        return label
    }
    
    private mutating func handle(newValue: String?) {
        modifiers.binding = BlockModifier(keyPath: \UILabel.text, value: newValue)
    }
    
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        return modified(BlockModifier(keyPath: \UILabel.textAlignment, value: alignment))
    }
    
    public func color(_ color: UIColor) -> Self {
        return modified(BlockModifier(keyPath: \UILabel.textColor, value: color))
    }
    
    public func font(_ font: UIFont) -> Self {
        return modified(BlockModifier(keyPath: \UILabel.font, value: font))
    }
    
    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        return modified(BlockModifier(keyPath: \UILabel.lineBreakMode, value: lineBreakMode))
    }
    
    public func numberOfLines(_ numberOfLines: Int) -> Self {
        return modified(BlockModifier(keyPath: \UILabel.numberOfLines, value: numberOfLines))
    }
    
    public func placeholder(_ text: String) -> Self {
        return modified(BlockModifier(keyPath: \UILabel.text, value: text))
    }
    
    public func with(_ block: @escaping BlockModifierBlockType<UILabel>) -> Self {
        return modified(BlockModifierBlock(block))
    }
}

extension LabelBlock {
    public static func footnote(_ text: String) -> LabelBlock {
        return LabelBlock(text)
            .color(.lightGray)
            .numberOfLines(0)
            .font(.preferredFont(forTextStyle: .footnote))
    }
}

fileprivate class BlockLabel: UILabel {
    var textInsets: UIEdgeInsets? {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        guard let textInsets = textInsets else {
            return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        }
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top, left: -textInsets.left, bottom: -textInsets.bottom, right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        guard let textInsets = textInsets else {
            super.drawText(in: rect)
            return
        }
        super.drawText(in: rect.inset(by: textInsets))
    }
}
