//
//  ViewController.swift
//  SwiftUIKitExample
//
//  Created by Andrey Zonov on 13.12.2020.
//

import UIKit
import SwiftUIKit


class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let vc = ExampleBlockView().controller(with: BlockContext())
        present(vc, animated: true)
    }
}

struct ExampleBlockView: BlockView {
    
    func block(_ context: BlockContext) -> Block {
        return VStackBlock([
            LabelBlock("Title")
                .font(UIFont.systemFont(ofSize: 30))
                .color(UIColor.blue)
                .numberOfLines(2),
            LabelBlock("Subtitle")
                .font(UIFont.systemFont(ofSize: 17))
                .color(UIColor.black)
                .numberOfLines(0),
            HStackBlock([
                LabelBlock("Left"),
                FlexibleSpaceBlock(),
                LabelBlock("Right")
            ]),
            FlexibleSpaceBlock(),
            
        ])
        .padding(insets: UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16))
        .backgroundColor(.white)
    }
}

