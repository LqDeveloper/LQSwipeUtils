//
//  LQViewController.swift
//  PageViewControllerDemo
//
//  Created by Quan Li on 2019/8/26.
//  Copyright © 2019 williamoneilchina. All rights reserved.
//

import UIKit

class LQViewController: UIViewController {

    @IBOutlet weak var swipeView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let swipe = swipeView as? LQSwipeDemoView else {
           return
        }
        swipe.stopLoop()
    }

}
