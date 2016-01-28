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
        
        let metaSpin = MetaSpin(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        metaSpin.center = view.center
        metaSpin.ballFillColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1.0)
        metaSpin.centralBallRadius = 50.0
        metaSpin.sideBallRadius = 15.0
        metaSpin.speed = 0.02
        metaSpin.frameInterval = 1
        
        view.backgroundColor = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1.0)
        
        view.addSubview(metaSpin)
        
        metaSpin.animateSideBall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

