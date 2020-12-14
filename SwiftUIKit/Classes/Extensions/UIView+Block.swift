//
//  UIView+Block.swift
//  SwiftUIKit
//
//  Created by Andrey Zonov on 13.12.2020.
//

public struct BlockViewAttributes {
    
    var position: Blocks.Position = .fill
    var safeArea = true
    
}

public protocol BlockViewExtendable: UIView {
    
    var Block: BlockViewAttributes { get set }
    
    func build(block: Block, with context: BlockContext)
    func addConstrainedSubview(_ subview: UIView, with padding: UIEdgeInsets?)
    
}

public protocol BlockViewCustomConstraints {
    func addCustomConstraints()
}

extension UIView: BlockViewExtendable {
    
    private static var BlockViewAttributesKey: UInt8 = 0
    
    public func build(block: Block, with context: BlockContext) {
        let context = context.set(view: self)
        let view = block.build(with: context)
        addConstrainedSubview(view)
    }
    
    public func addConstrainedSubview(_ subview: UIView, with padding: UIEdgeInsets? = nil) {
        let attributes = subview.Block
        let padding = padding ?? UIEdgeInsets.zero
        
        self.addSubview(subview)
        
        attributes.position.apply(to: subview, padding: padding, safeArea: attributes.safeArea)
        
        if let customView = subview as? BlockViewCustomConstraints {
            customView.addCustomConstraints()
        }
    }
    
    public var Block: BlockViewAttributes {
        get {
            if let attributes = objc_getAssociatedObject( self, &UIView.BlockViewAttributesKey ) as? BlockViewAttributes {
                return attributes
            }
            return BlockViewAttributes()
        }
        set {
            objc_setAssociatedObject(self, &UIView.BlockViewAttributesKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func viewWithID<T,V:UIView>(_ id: T) -> V? where T: RawRepresentable, T.RawValue == Int {
        return viewWithTag(id.rawValue) as? V
    }
    
}
