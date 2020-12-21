//
//  Block.swift
//  SwiftUIKit
//
//  Created by Andrey Zonov on 13.12.2020.
//

import UIKit

public protocol AnyBlock {}

public protocol BlockControllerType: AnyBlock {
    
    func controller(with context: BlockContext) -> UIViewController
}

public protocol BlockViewType: BlockControllerType {
    
    func build(with context: BlockContext) -> UIView
}

public typealias Block = BlockViewType

public struct Blocks { }

public protocol BlockContaining: Block {
    
    var block: Block { get }
}

public protocol BlocksContaining: Block {
    
    var blocks: [Block] { get }
}

extension BlockViewType {
    
    public func walk(_ process: (_ Block: Block) -> Void ) {
        func handle(_ block: Block) {
            process(block)
            if let block = block as? BlockContaining {
                handle(block)
            } else if let block = block as? BlocksContaining {
                block.blocks.forEach { handle($0) }
            }
        }
        handle(self)
    }
}

public struct BlockFactory { }

public protocol BlockViewNavigating: BlockView {
    
    func navigationController(with context: BlockContext) -> UINavigationController
    
}

extension BlockFactory {
    
    public static var defaultNavigationController: (_ context: BlockContext) -> UINavigationController = { _ in
        return UINavigationController()
    }
}

extension BlockViewNavigating {
    
    public func navigationController(with context: BlockContext) -> UINavigationController {
        BlockFactory.defaultNavigationController(context)
    }
}

extension BlockViewType {
    
    public func controller(with context: BlockContext) -> UIViewController {
        if let navigating = self as? BlockViewNavigating {
            let navigationController = navigating.navigationController(with: context)
            let viewController = UIBlockHostController(self, with: context)
            navigationController.addChild(viewController)
            return navigationController
        }
        return UIBlockHostController(self, with: context)
    }
}

extension BlockContext {
    
    public func rebuild() {
        self.viewController?.rebuild()
    }
}
