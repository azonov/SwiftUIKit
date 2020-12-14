//
//  ImageBlock.swift
//  SwiftUIKit
//
//  Created by Andrey Zonov on 13.12.2020.
//

import UIKit

public struct ImageBlock: BlockViewModifying,
                          CustomDebugStringConvertible
{
    
    public var debugDescription: String { "ImageBlock()" }
    
    public var modifiers = BlockModifiers()
    
    public init(_ image: UIImage) {
        self.modifiers.binding = BlockModifier(keyPath: \UIImageView.image, value: image)
    }
    
    public init(named name: String) {
        self.modifiers.binding = BlockModifierBlock<UIImageView> { view, context in
            if let image = UIImage(named: name) {
                view.image = image
            }
        }
    }
    
    public func build(with context: BlockContext) -> UIView {
        let view = UIImageView()
        let context = modifiers.modified(context, for: view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        modifiers.apply(to: view, with: context)
        
        return view
    }
    
    public func placeholder(_ image: UIImage) -> Self {
        return modified(BlockModifier(keyPath: \UIImageView.image, value: image))
    }
    
    public func with(_ block: @escaping BlockModifierBlockType<UIImageView>) -> Self {
        return modified(BlockModifierBlock(block))
    }
}
