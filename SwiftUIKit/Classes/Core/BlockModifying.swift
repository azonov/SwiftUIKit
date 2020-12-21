//
//  BlockModifying.swift
//  SwiftUIKit
//
//  Created by Andrey Zonov on 13.12.2020.
//

import UIKit

public struct BlockModifiers {
    
    public var list: Array<AnyBlockModifier>?
    public var contextModifier: BlockContextModifier?
    public var binding: AnyBlockModifier? = nil
    public var padding: UIEdgeInsets? = nil
    public init() {}

    public func apply(to view: UIView, with context: BlockContext) {
        self.binding?.apply(to: view, with: context)
        self.list?.forEach { $0.apply(to: view, with: context) }
    }
    
    public func modified(_ context: BlockContext, for view: UIView) -> BlockContext {
        return (contextModifier?(context) ?? context).set(view: view)
    }
}

public protocol BlockModifying: Block {
    var modifiers: BlockModifiers { get set }
}

extension BlockModifying {
    
    public func modified(_ modifier: AnyBlockModifier) -> Self {
        var Block = self
        if Block.modifiers.list == nil {
            Block.modifiers.list = [modifier]
            Block.modifiers.list?.reserveCapacity(8)
        } else {
            Block.modifiers.list?.append(modifier)
        }
        return Block
    }
    
    public func modified(_ modifier: (_ Block: inout Self) -> Void) -> Self {
        var Block = self
        modifier(&Block)
        return Block
    }
}

public protocol AnyBlockModifier {
    func apply(to view: UIView, with context: BlockContext)
}

public struct BlockModifier<View:UIView, Value>: AnyBlockModifier {
    
    public let keyPath: WritableKeyPath<View, Value>
    public let value: Value
    
    public init(keyPath: WritableKeyPath<View, Value>, value: Value) {
        self.keyPath = keyPath
        self.value = value
    }
    
    public func apply(to view: UIView, with context: BlockContext) {
        if var view = view as? View {
            view[keyPath: keyPath] = value
        }
    }
}


public typealias BlockModifierBlockType<View:UIView> = (View, BlockContext) -> Void

public struct BlockModifierBlock<View:UIView>: AnyBlockModifier {
    
    public let modifier: BlockModifierBlockType<View>
    
    public init(_ modifier: @escaping BlockModifierBlockType<View>) {
        self.modifier = modifier
    }
    
    public func apply(to view: UIView, with context: BlockContext) {
        if let view = view as? View {
            modifier(view, context)
        }
    }
}

extension BlockViewModifying {
    
    public func accessibilityLabel(_ accessibilityLabel: String?) -> Self {
        return modified(BlockModifier(keyPath: \UIView.accessibilityLabel, value: accessibilityLabel))
    }
    
    public func alpha(_ alpha: CGFloat) -> Self {
        return modified(BlockModifier(keyPath: \UIView.alpha, value: alpha))
    }
    
    public func backgroundColor(_ backgroundColor: UIColor) -> Self {
        return modified(BlockModifier(keyPath: \UIView.backgroundColor, value: backgroundColor))
    }
    
    public func clipsToBounds(_ clipsToBounds: Bool) -> Self {
        return modified(BlockModifier(keyPath: \UIView.clipsToBounds, value: clipsToBounds))
    }
    
    public func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        return modified(BlockModifier(keyPath: \UIView.contentMode, value: contentMode))
    }
    
    public func hidden(_ isHidden: Bool) -> Self {
        return modified(BlockModifier(keyPath: \UIView.isHidden, value: isHidden))
    }
    
    public func tag<T>(_ id: T) -> Self where T: RawRepresentable, T.RawValue == Int {
        return modified(BlockModifier(keyPath: \UIView.tag, value: id.rawValue))
    }
    
    public func tag(_ tag: Int) -> Self {
        return modified(BlockModifier(keyPath: \UIView.tag, value: tag))
    }
    
    public func userInteractionEnabled (_ isUserInteractionEnabled: Bool) -> Self {
        return modified(BlockModifier(keyPath: \UIView.isUserInteractionEnabled, value: isUserInteractionEnabled))
    }
    
    public func contentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        return modified(BlockModifierBlock<UIView> { view, _ in
            view.setContentCompressionResistancePriority(priority, for: axis)
        })
    }
    
    public func contentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        return modified(BlockModifierBlock<UIView> { view, _ in
            view.setContentHuggingPriority(priority, for: axis)
        })
    }
    
    public func height(_ height: CGFloat, priority: Float = 999) -> Self {
        return modified(BlockModifierBlock<UIView> { view, _ in
            let height = view.heightAnchor.constraint(equalToConstant: height)
            height.priority = UILayoutPriority(priority)
            height.isActive = true
        })
    }
    
    public func height(min height: CGFloat, priority: Float = 999) -> Self {
        return modified(BlockModifierBlock<UIView> { view, _ in
            let height = view.heightAnchor.constraint(greaterThanOrEqualToConstant: height)
            height.priority = UILayoutPriority(priority)
            height.isActive = true
        })
    }
    
    public func height(max height: CGFloat, priority: Float = 999) -> Self {
        return modified(BlockModifierBlock<UIView> { view, _ in
            let height = view.heightAnchor.constraint(lessThanOrEqualToConstant: height)
            height.priority = UILayoutPriority(priority)
            height.isActive = true
        })
    }
    
    public func width(_ width: CGFloat, priority: Float = 999) -> Self {
        return modified(BlockModifierBlock<UIView> { view, _ in
            let width = view.widthAnchor.constraint(equalToConstant: width)
            width.priority = UILayoutPriority(priority)
            width.isActive = true
        })
    }
    
    public func width(min width: CGFloat, priority: Float = 999) -> Self {
        return modified(BlockModifierBlock<UIView> { view, _ in
            let width = view.widthAnchor.constraint(greaterThanOrEqualToConstant: width)
            width.priority = UILayoutPriority(priority)
            width.isActive = true
        })
    }
    
    public func width(max width: CGFloat, priority: Float = 999) -> Self {
        return modified(BlockModifierBlock<UIView> { view, _ in
            let width = view.widthAnchor.constraint(lessThanOrEqualToConstant: width)
            width.priority = UILayoutPriority(priority)
            width.isActive = true
        })
    }
    
    public func border(color: UIColor = .gray, width: CGFloat = 1, radius: CGFloat = 0) -> Self {
        return modified(BlockModifierBlock({ (view, context) in
            view.layer.borderColor = color.cgColor
            view.layer.borderWidth = width
            view.layer.cornerRadius = radius
            view.clipsToBounds = true
        }))
    }
    
    public func borderColor(_ borderColor: UIColor) -> Self {
        return modified(BlockModifier(keyPath: \UIView.layer.borderColor, value: borderColor.cgColor))
    }
    
    public func borderWidth(_ borderWidth: CGFloat) -> Self {
        return modified(BlockModifier(keyPath: \UIView.layer.borderWidth, value: borderWidth))
    }
    
    public func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        return modified(BlockModifierBlock({ (view, context) in
            view.layer.cornerRadius = cornerRadius
            view.clipsToBounds = true
        }))
    }
    
    public func shadow(offset: CGSize, color: UIColor = .gray, opacity: Float = 0.5, radius: CGFloat = 0) -> Self {
        return modified(BlockModifierBlock({ (view, context) in
            view.layer.shadowOffset = offset
            view.layer.shadowColor = color.cgColor
            view.layer.shadowOpacity = opacity
            view.layer.shadowRadius = radius
            view.clipsToBounds = false
        }))
    }
    
    public func safeArea(_ value: Bool) -> Self {
        return modified(BlockModifier(keyPath: \UIView.block.safeArea, value: value))
    }
    
    public func with<View:UIView>(_ block: @escaping BlockModifierBlockType<View>) -> Self {
        return modified(BlockModifierBlock(block))
    }
}
