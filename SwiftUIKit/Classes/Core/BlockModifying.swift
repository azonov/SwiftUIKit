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
    
}
