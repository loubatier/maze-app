//
//  ViewController.swift
//  game-app
//
//  Created by Lou Batier on 15/05/2019.
//  Copyright © 2019 Lou Batier. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    var motion = CMMotionManager()
    var animator: UIDynamicAnimator? = nil

    @IBOutlet weak var ball: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

        ball.frame.origin.x = self.view.frame.size.width / 2
        ball.frame.origin.y = self.view.frame.size.height / 2

        ball.layer.cornerRadius = 25
        startBallMotion()
    }
    
    func startBallMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue.main) {
                (dm, err) in
                if let dm = dm {
                    self.ball.frame.origin.x = self.ball.frame.origin.x + (20 * CGFloat(dm.attitude.roll))
                    self.ball.frame.origin.y = self.ball.frame.origin.y + (10 * CGFloat(dm.attitude.pitch))
                }
            }
        }
    }


}

