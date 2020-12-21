//
//  BlockContext.swift
//  SwiftUIKit
//
//  Created by Andrey Zonov on 13.12.2020.
//

import UIKit

public struct BlockContext {
    
    public weak var viewController: UIBlockHostController?
    public weak var parentView: UIView?
    public weak var view: UIView?
    public var attributes: [String:Any?] = [:]
    
    public init() {}
    
    public func set(view: UIView) -> BlockContext {
        var context = self
        context.parentView = context.view
        context.view = view
        return context
    }
    
    public func get<T>(_ key: String) -> T {
        (attributes[key] as? T)!
    }
    
    public func get<T>(_ type: T.Type = T.self) -> T {
        (attributes[String(describing: type)] as? T)!
    }
    
    public func getWeak<T>(_ type: T.Type = T.self) -> T? {
        ((attributes[String(describing: type)] as? WeakBox)?.object as? T)
    }
    
    public func find<T>(_ key: String) -> T? {
        attributes[key] as? T
    }
    
    public func find<T>(_ type: T.Type = T.self) -> T? {
        attributes[String(describing: type)] as? T
    }
    
    public func put<T>(_ object: T) -> BlockContext {
        var context = self
        context.attributes[String(describing: T.self)] = object
        return context
    }
    
    public func putWeak<T:AnyObject>(_ object: T) -> BlockContext {
        var context = self
        context.attributes[String(describing: T.self)] = WeakBox(object: object)
        return context
    }
    
    public func set<T>(_ value: T?, for key: String) -> BlockContext {
        var context = self
        context.attributes[key] = value
        return context
    }
    
    public func set(viewController: UIBlockHostController) -> BlockContext {
        var context = self
        context.viewController = viewController
        return context
    }
}

fileprivate struct WeakBox {
    weak var object: AnyObject?
}

public typealias BlockContextModifier = (BlockContext) -> BlockContext

extension BlockViewModifying {
    
    public func context(_ modifier: @escaping BlockContextModifier) -> Self {
        return modified { $0.modifiers.contextModifier = modifier }
    }
}

public protocol BlockViewModifying: BlockModifying {}
