//
//  Spacing.swift
//  SwiftUIKit
//
//  Created by Andrey Zonov on 13.12.2020.
//

import UIKit

public typealias FlexibleSpaceBlock = SpacerBlock

public struct SpacerBlock: Block
                            , CustomDebugStringConvertible {
    
    public var debugDescription: String { "SpacerBlock()" }
    
    private var h: CGFloat?
    private var v: CGFloat?
    
    public init(h: CGFloat? = nil, v: CGFloat? = nil) {
        self.h = h
        self.v = v
    }
    
    public func build(with context: BlockContext) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        if let h = h {
            view.widthAnchor.constraint(equalToConstant: h).isActive = true
        } else {
            view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
        if let v = v {
            view.heightAnchor.constraint(equalToConstant: v).isActive = true
        } else {
            view.setContentHuggingPriority(.defaultLow, for: .vertical)
        }
        return view
    }
}

