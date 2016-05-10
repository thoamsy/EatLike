//
//  DiscoverViewController.swift
//  EatLike
//
//  Created by Queen Y on 16/4/4.
//  Copyright © 2016年 Queen. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    @IBOutlet weak var backgroundBlurImage: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likesTotalLabel: UILabel!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var restaurantImageButton: UIButton!
    @IBOutlet weak var dialogView: UIView!

    var animator : UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var gravityBehaviour : UIGravityBehavior!
    var snapBehavior : UISnapBehavior!
    var isAnimated = false

    lazy private var discovers = [
        DiscoverRestaurants(
            name: "Red Flag",
            userName: "Mark",
            foodName: "Chicken Eight",
            category: "Hotel",
            isLike: false,
            note: "Very Good",
            likesTotal: 90,
            detailImage: UIImage(named: "grahamavenuemeats")!,
            authorImage: UIImage(named: "avatar4")!),

        DiscoverRestaurants(
            name: "Yellow Books",
            userName: "Your Father",
            foodName: "CatShits",
            category: "oo",
            isLike: false,
            note: "你他妈的就是一个傻逼, 我日你麻痹",
            likesTotal: 39,
            detailImage: UIImage(named: "petiteoyster")!,
            authorImage: UIImage(named: "avatar")!)
    ]
    var index = 0

    @IBAction func callRestaurant(sender: UIButton) {
        let string = sender.titleLabel?.text
        presentViewController(call(string!)!, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if isAnimated {
            dialogView.alpha = 0
        }
        configureView()
        getBlurView(backgroundBlurImage, style: .Dark)
        getBlurView(headerView, style: .Dark)

        animator = UIDynamicAnimator(referenceView: view)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.hidden = false
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

        if isAnimated {
            animatedView()
            isAnimated = false
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "modalFriend" {
            let nav = segue.destinationViewController as! UINavigationController
            let friendVC = nav.topViewController as! FriendRestaurantViewController
            friendVC.friendData = discovers[index]
        }
    }


    // MARK: Action

    @IBAction func handlerPanGesture(sender: UIPanGestureRecognizer) {
        let myView = dialogView
        let location = sender.locationInView(view)
        let boxLocation = sender.locationInView(dialogView)

        if sender.state == UIGestureRecognizerState.Began {
            if snapBehavior != nil {
                animator.removeBehavior(snapBehavior)
            }

            // 添加钟摆效果并且计算偏移量, 摆动终点就是手指停留的位置
            let centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(myView.bounds), boxLocation.y - CGRectGetMidY(myView.bounds));
            attachmentBehavior = UIAttachmentBehavior(item: myView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavior.frequency = 0.0

            animator.addBehavior(attachmentBehavior)
        }
        else if sender.state == UIGestureRecognizerState.Changed {
            attachmentBehavior.anchorPoint = location
        }
        else if sender.state == UIGestureRecognizerState.Ended {
            animator.removeBehavior(attachmentBehavior)

            let translation = sender.translationInView(view)
            // 如果是向下移动超过了 100 点, 就移除所有之前的行为, 附加重力效果
            // 并且开始刷新界面
            if translation.y > 100 {
                animator.removeAllBehaviors()

                // 添加重力效果
                let gravity = UIGravityBehavior(items: [dialogView])
                gravity.gravityDirection = CGVectorMake(0, 10)
                animator.addBehavior(gravity)

                // 使用线程刷新
                delay(0.3) {
                    self.refreshView()
                }
            } else {
                // otherwise 添加晃动动作
                snapBehavior = UISnapBehavior(item: myView, snapToPoint: view.center)
                animator.addBehavior(snapBehavior)
            }
        }
    }

    @IBAction func likeButtonDidPressed(sender: UIButton) {
        /* let tintColor = sender.tintColor
        let indexPath = getCurrentIndexPath()
        guard let index = indexPath else { return }
        let row = index.row
        if tintColor == UIColor.blueColor() {
            discovers[row].likesTotal += 1
            sender.tintColor = UIColor.redColor()
            currentCell.changeLikeTotal(true)
        } else {
            discovers[row].likesTotal -= 1
            sender.tintColor = UIColor.blueColor()
            currentCell.changeLikeTotal(false)
        } */
    }

// MARK: - Helper Function

    private func refreshView() {
        index += 1
        if index == discovers.count {
            index = 0
        }

        animator.removeAllBehaviors()
        snapBehavior = UISnapBehavior(item: dialogView, snapToPoint: view.center)
        attachmentBehavior.anchorPoint = view.center

        dialogView.center = view.center
        isAnimated = true
        viewDidAppear(true)
        configureView()
    }

    private func animatedView() {
        let scale = CGAffineTransformMakeScale(0.5, 0.5)
        let translate = CGAffineTransformMakeTranslation(0, -200)
        dialogView.transform = CGAffineTransformConcat(scale, translate)
        spring(0.5, delay: 0.2) {
            self.dialogView.transform = CGAffineTransformIdentity
        }
    }

    private func configureView() {
        let restaurant = discovers[index]
        backgroundBlurImage.image = restaurant.detailImage
        userImageView.image = restaurant.authorImage
        restaurantImageButton.setImage(
            restaurant.detailImage, forState: .Normal)
        restaurantLabel.text = restaurant.foodName
        likesTotalLabel.text = "\(restaurant.likesTotal)"
        userNameLabel.text = restaurant.userName
        userNameLabel.text?.appendContentsOf(" | \(restaurant.name)")

        dialogView.alpha = 1
    }
}

