
import UIKit

class SwipeSegue: UIStoryboardSegue {

    override func perform() {
        destinationViewController.transitioningDelegate = self
        super.perform()
    }
}

extension SwipeSegue: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
                             sourceController source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {

        // Challenge is only swipe to dismiss, so still scale up
        return ScalePresentAnimator()
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SwipeDismissAnimator()
    }
}

protocol ViewSwipeable {
    var swipeDirection: UISwipeGestureRecognizerDirection { get }
}

class SwipeDismissAnimator:NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5

    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        // Get the views from the transition context
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!

        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)


        // Add the to- view to the transition context
        if let fromView = fromView {
            if let toView = toView {
                transitionContext.containerView()?.insertSubview(toView, belowSubview: fromView)
            }
        }

        // Work out the final frame for the animation
        var finalFrame = transitionContext.initialFrameForViewController(fromViewController)
        // Center final frame so it slides  vertically
        let toFinalFrame = transitionContext.finalFrameForViewController(toViewController)
        finalFrame.origin.x = toFinalFrame.width/2 - finalFrame.width/2

        if let fromViewController = fromViewController as? ViewSwipeable {
            let direction = fromViewController.swipeDirection
            switch direction {
            case UISwipeGestureRecognizerDirection.Up:
                finalFrame.origin.y = -finalFrame.height
            case UISwipeGestureRecognizerDirection.Down:
                finalFrame.origin.y = UIWindow().bounds.height
            default:()
            }
        }else {
            // Not Swipeable
            print("Warning: Controller \(fromViewController) does not conform to ViewSwipeable")
        }
        // Perform the animation
        let duration = transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, animations: {
            fromView?.frame = finalFrame
            }, completion: {
                finished in
                // Clean up the transition context
                transitionContext.completeTransition(true)
        })
    }
}
