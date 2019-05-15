//
//  ViewController.swift
//  game-app
//
//  Created by Lou Batier on 15/05/2019.
//  Copyright © 2019 Lou Batier. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {

    var motion = CMMotionManager()
    var animator: UIDynamicAnimator? = nil
    var collision: UICollisionBehavior!

    @IBOutlet weak var ball: UIView!
    @IBOutlet weak var finishArea: UIView!
    
    var grav: UIGravityBehavior!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let wall1 = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 200, width: 275, height: 200))
        wall1.backgroundColor = UIColor(displayP3Red: 230/255, green: 118/255, blue: 118/255, alpha: 1)
        view.addSubview(wall1)
        
        let wall2 = UIView(frame: CGRect(x: self.view.frame.width - 275, y: (self.view.frame.height / 2) - 40, width: 275, height: 80))
        wall2.backgroundColor = UIColor(displayP3Red: 230/255, green: 118/255, blue: 118/255, alpha: 1)
        view.addSubview(wall2)
        

        ball.layer.cornerRadius = 25
        finishArea.layer.cornerRadius = 5
        ball.frame.origin = CGPoint(x: self.view.frame.width - ball.frame.width, y: self.view.frame.height - ball.frame.height)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        animator?.delegate = self
        
        grav = UIGravityBehavior(items: [ball])
        grav.magnitude = 8
        animator?.addBehavior(grav)
        
        let coll = UICollisionBehavior(items: [ball])
        coll.translatesReferenceBoundsIntoBoundary = true
        coll.addBoundary(withIdentifier: "wall1" as NSCopying, for: UIBezierPath(rect: wall1.frame))
        coll.addBoundary(withIdentifier: "wall2" as NSCopying, for: UIBezierPath(rect: wall2.frame))
        coll.collisionDelegate = self
        animator?.addBehavior(coll)
        
        startBallMotion()
    }
    
    
    func startBallMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue.main) {
                (dm, err) in
                if let dm = dm {
                    self.pushBall(roll: 0.2 * dm.attitude.roll, pitch: 0.2 * dm.attitude.pitch)
                }
            }
        }
    }
    
    
    func pushBall(roll: Double, pitch: Double) {
        let push = UIPushBehavior(items: [ball], mode: .instantaneous)
        push.pushDirection = CGVector(dx: grav.magnitude * CGFloat(sin(roll)), dy: grav.magnitude * CGFloat(sin(pitch)))
        animator?.addBehavior(push)
    }
}

