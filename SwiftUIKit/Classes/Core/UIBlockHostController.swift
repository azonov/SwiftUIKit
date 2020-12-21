//
//  UIBlockHostController.swift
//  SwiftUIKit
//
//  Created by Andrey Zonov on 21.12.2020.
//

import UIKit

public class UIBlockHostController: UIViewController {
    
    public var block: Block!
    public var context: BlockContext!
    
    public init(_ block: Block, with context: BlockContext? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.block = block
        self.context = (context ?? BlockContext())
            .set(viewController: self)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEINIT UIBlockViewController")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        build()
    }
    
    public func build() {
        view.build(block: block, with: context)
    }
    
    public func rebuild() {
        build()
    }
}
