//
//  BottomSheetTransition.swift
//  CallMe
//
//  Created by Luca Lancellotti on 27/07/22.
//

import UIKit

class BottomSheetTransition {
    class Present: NSObject, UIViewControllerAnimatedTransitioning {
        var animator: UIViewImplicitlyAnimating?

        func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.3
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let animator = interruptibleAnimator(using: transitionContext)
            animator.startAnimation()
        }

        func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
            if self.animator != nil {
                return self.animator!
            }

            let container = transitionContext.containerView
            let fromVC = transitionContext.viewController(forKey: .from)!

            let fromViewInitialFrame = transitionContext.initialFrame(for: fromVC)
            let fromViewFinalFrame = fromViewInitialFrame

            let fromView = fromVC.view!

            // BLUR
            let renderer = UIGraphicsImageRenderer(size: fromView.bounds.size)
            let image = renderer.image { _ in
                fromView.drawHierarchy(in: fromView.bounds, afterScreenUpdates: true)
            }
            let viewBlur = UIView()
            viewBlur.tag = 123
            viewBlur.layer.opacity = 0
            viewBlur.frame = fromView.bounds
            viewBlur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            fromView.addSubview(viewBlur)
            let imageView = UIImageView(image: Functions.blurredImage(image, radius: 16))
            imageView.contentMode = .scaleToFill
            imageView.frame = fromView.bounds
            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            viewBlur.addSubview(imageView)
            let whiteView = UIView()
            whiteView.backgroundColor = UIColor(red: 214 / 255, green: 223 / 255, blue: 255 / 255, alpha: 0.2)
            whiteView.frame = fromView.bounds
            whiteView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            viewBlur.addSubview(whiteView)

            let toView = transitionContext.view(forKey: .to)!

            var toViewInitialFrame = fromViewInitialFrame
            toViewInitialFrame.origin.y = toView.frame.size.height

            toView.frame = toViewInitialFrame
            container.addSubview(toView)

            let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), curve: .easeInOut) {
                viewBlur.layer.opacity = 1
                toView.frame = fromViewInitialFrame
                fromView.frame = fromViewFinalFrame
            }

            animator.addCompletion { _ in
                transitionContext.completeTransition(true)
            }

            self.animator = animator

            return animator
        }

        func animationEnded(_: Bool) {
            animator = nil
        }
    }

    class Dismiss: NSObject, UIViewControllerAnimatedTransitioning {
        var animator: UIViewImplicitlyAnimating?

        func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.3
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let animator = interruptibleAnimator(using: transitionContext)
            animator.startAnimation()
        }

        func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
            if self.animator != nil {
                return self.animator!
            }

            let fromVC = transitionContext.viewController(forKey: .from)!

            var fromViewInitialFrame = transitionContext.initialFrame(for: fromVC)
            fromViewInitialFrame.origin.x = 0
            var fromViewFinalFrame = fromViewInitialFrame
            fromViewFinalFrame.origin.y = fromViewFinalFrame.height

            let fromView = fromVC.view!
            let toView = transitionContext.viewController(forKey: .to)!.view!
            let blurView = toView.viewWithTag(123)

            let toViewInitialFrame = fromViewInitialFrame

            toView.frame = toViewInitialFrame

            let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), curve: .easeInOut) {
                blurView?.layer.opacity = 0
                toView.frame = fromViewInitialFrame
                fromView.frame = fromViewFinalFrame
            }

            animator.addCompletion { _ in
                blurView?.removeFromSuperview()
                transitionContext.completeTransition(true)
            }

            self.animator = animator

            return animator
        }

        func animationEnded(_: Bool) {
            animator = nil
        }
    }
}
