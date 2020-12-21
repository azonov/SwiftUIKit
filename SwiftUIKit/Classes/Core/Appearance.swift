//
//  Appearance.swift
//  SwiftUIKit
//
//  Created by Andrey Zonov on 13.12.2020.
//

import UIKit

extension BlockContext {
    
    public var theme: BlockAppearance {
        if let theme = find(BlockAppearance.self) {
            return theme
        }
        return BlockAppearance.defaultTheme
    }
    
    public func set(theme: BlockAppearance) -> BlockContext {
        return put(theme as BlockAppearance)
    }
}

public struct BlockAppearance {
    
    public struct Color {
        
        public var accent: UIColor
        public var link: UIColor
        
        public var text: UIColor
        public var secondaryText: UIColor
        
    }
    
    public struct Font {
        public var body: UIFont
    }
    
    public var color: Color
    public var font: Font
    
    public mutating func update(_ updater: @escaping (_ theme: inout BlockAppearance) -> Void) {
        updater(&self)
    }
    
    public static var defaultTheme: BlockAppearance = {
        if #available(iOS 13, *) {
            let color = BlockAppearance.Color(
                accent: .systemBlue,
                link: .systemBlue,
                text: .label,
                secondaryText: .secondaryLabel
            )
            let font = BlockAppearance.Font(
                body: UIFont.preferredFont(forTextStyle: .body)
            )
            return BlockAppearance(color: color, font: font)
        } else {
            let color = BlockAppearance.Color(
                accent: .blue,
                link: .blue,
                text: .darkText,
                secondaryText: .gray
            )
            let font = BlockAppearance.Font(
                body: UIFont.preferredFont(forTextStyle: .body)
            )
            return BlockAppearance(color: color, font: font)
        }
    }()
}

extension BlockViewModifying {
    
    public func theme(_ theme: BlockAppearance) -> Self {
        let modifier: BlockContextModifier = { $0.set(theme: theme) }
        return modified { $0.modifiers.contextModifier = modifier }
    }
    
    public func theme(_ update: @escaping (_ theme: inout BlockAppearance) -> Void) -> Self {
        let modifier: BlockContextModifier = { context in
            var theme = context.theme
            update(&theme)
            return context.set(theme: theme)
        }
        return modified { $0.modifiers.contextModifier = modifier }
    }
}
