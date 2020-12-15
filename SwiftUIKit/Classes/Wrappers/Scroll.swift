//
//  Scroll.swift
//  SwiftUIKit
//
//  Created by Andrey Zonov on 14.12.2020.
//

import UIKit

extension Blocks {
    public enum ScrollAxis {
        case both
        case vertical
        case horizontal
    }
}

public struct ScrollBlock
: BlockViewModifying
  , BlockContaining
  , BlockPadding
  , CustomDebugStringConvertible {
    
    public var debugDescription: String { "ScrollBlock()" }
    
    public var block: Block
    public var modifiers = BlockModifiers()
    public var axis = Blocks.ScrollAxis.vertical
    
    public init(_ block: Block) {
        self.block = block
    }
    
    public func build(with context: BlockContext) -> UIView {
        
        let view = BlockScrollView()
        let context = modifiers.modified(context, for: view)
        let contentView = block.build(with: context)
        let padding = self.modifiers.padding ?? UIEdgeInsets.zero
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = axis
        view.padding = padding
        view.addSubview(contentView)
        
        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding.top).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding.left).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding.bottom).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding.right).isActive = true
        
        modifiers.apply(to: view, with: context)
        
        return view
    }
    
    public func axis(_ axis: Blocks.ScrollAxis) -> Self {
        return modified { $0.axis = axis }
    }
    
    /// Pass an UIScrollViewDelegate object and it will be assigned as the delegate for the generated UIScrollView.
    public func delegate(_ delegate: UIScrollViewDelegate) -> Self {
        return modified(BlockModifierBlock<BlockScrollView> { view, _ in
            view.delegateReference = delegate
            view.delegate = delegate
        })
    }
    
    public func with(_ block: @escaping BlockModifierBlockType<UIScrollView>) -> Self {
        return modified(BlockModifierBlock(block))
    }
    
}

internal class BlockScrollView: UIScrollView, BlockViewCustomConstraints {
    
    var axis: Blocks.ScrollAxis = .both
    var delegateReference: UIScrollViewDelegate?
    var padding: UIEdgeInsets!
    
    func addCustomConstraints() {
        guard let superview = superview, let subview = subviews.first else { return }
        switch axis {
        case .vertical:
            let padding = self.padding.left + self.padding.right
            subview.widthAnchor.constraint(equalTo: superview.widthAnchor, constant: -padding).isActive = true
        case .horizontal:
            let padding = self.padding.top + self.padding.bottom
            subview.heightAnchor.constraint(equalTo: superview.heightAnchor, constant: -padding).isActive = true
        case .both:
            break
        }
    }
    
}
