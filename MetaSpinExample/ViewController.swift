//
//  ViewController.swift
//  MetaSpinExample
//
//  Created by Jin Wang on 21/04/2015.
//  Copyright (c) 2015 uthoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let metaSpin = MetaSpin(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        metaSpin.center = view.center
        
        view.addSubview(metaSpin)
        
        metaSpin.animateSideBall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

