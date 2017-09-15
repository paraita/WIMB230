//
//  BusView.swift
//  WIMB230
//
//  Created by Paraita Wohler on 14/09/2017.
//  Copyright © 2017 Paraita. All rights reserved.
//

import UIKit
import Foundation
import PullToRefresh

open class PullToRefreshBus: PullToRefresh {

    public convenience init(at position: Position = .top) {
        let refreshView = Bundle(for: type(of: self)).loadNibNamed("BusView", owner: nil, options: nil)!.first as! BusView
        let animator =  BusAnimator(refreshView: refreshView)
        self.init(refreshView: refreshView, animator: animator, height : refreshView.frame.size.height, position : position)
    }
}

class BusView: UIView {

    @IBOutlet
    fileprivate var bus: UIImageView!

    @IBOutlet
    fileprivate var backWheel: UIImageView!

    @IBOutlet
    fileprivate var frontWheel: UIImageView!

}

class BusAnimator: NSObject, RefreshViewAnimator {

    fileprivate let refreshView: BusView
    fileprivate let refreshViewHeight: CGFloat
    fileprivate let backWheelX: CGFloat
    fileprivate let frontWheelX: CGFloat

    init(refreshView: BusView) {
        self.refreshView = refreshView
        self.refreshViewHeight = refreshView.frame.height
        self.backWheelX = refreshView.backWheel.center.x
        self.frontWheelX = refreshView.frontWheel.center.x
    }

    public func animate(_ state: State) {
        switch state {
        case .initial:
            print("initial state")
            resetAnimationLayout()
        case .releasing(let progress):
            print("progress: \(progress)")
            refreshView.bus.alpha = progress
            refreshView.backWheel.alpha = progress
            refreshView.frontWheel.alpha = progress
        case .loading:
            print("loading in progress")
            UIView.animate(withDuration: 0.5, delay: 0.5, options: [.autoreverse, .repeat],
                           animations: {
                let oldPosition = self.refreshView.bus.center
                self.refreshView.bus.center = CGPoint(x: oldPosition.x,
                                                  y: oldPosition.y-2)
                self.refreshView.backWheel.transform = self.refreshView.backWheel.transform.rotated(by: CGFloat(Double.pi / 2))
                self.refreshView.frontWheel.transform = self.refreshView.frontWheel.transform.rotated(by: CGFloat(Double.pi / 2))
            })
        case .finished:
            print("finished state")
            resetAnimationLayout()
        }
    }

    func resetAnimationLayout() {
        let centerX = refreshView.frame.width / 2
        let centerY = refreshViewHeight / 2
        print("refreshView dimension: \(refreshView.frame.size)")
        print("bus dimension: \(refreshView.bus.frame.size)")
        print("centerX: \(centerX), centerY: \(centerY)")
        refreshView.bus.center = CGPoint(x: centerX, y: centerY)
        refreshView.backWheel.center = CGPoint(x: centerX - 61.2,
                                          y: refreshView.backWheel.center.y)
        refreshView.frontWheel.center = CGPoint(x: centerX + 48,
                                           y: refreshView.frontWheel.center.y)
        refreshView.backWheel.alpha = 0
        refreshView.frontWheel.alpha = 0
        refreshView.bus.alpha = 0
        //refreshView.backgroundColor = UIColor.blue
        refreshView.frame.size = CGSize(width: refreshView.frame.size.width,
                                    height: refreshView.bus.frame.size.height)
        self.refreshView.bus.layer.removeAllAnimations()
    }

}
