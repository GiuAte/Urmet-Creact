//
//  LoaderViewController.swift
//  CallMe
//
//  Created by Luca Lancellotti on 16/09/22.
//

import UIKit

public class LoaderViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!

    public init() {
        super.init(nibName: nil, bundle: Bundle(for: LoaderViewController.self))

        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.main.async {
            let rotation: CABasicAnimation = .init(keyPath: "transform.rotation.z")
            rotation.toValue = NSNumber(value: Double.pi * 2)
            rotation.duration = 2.5
            rotation.isCumulative = true
            rotation.repeatCount = .infinity
            self.imageView.layer.add(rotation, forKey: "rotationAnimation")
        }
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension LoaderViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LoaderTransition.Present()
    }

    public func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LoaderTransition.Dismiss()
    }
}

enum LoaderTransition {
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
            toView.frame = transitionContext.initialFrame(for: fromVC)
            toView.alpha = 0
            container.addSubview(toView)

            let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), curve: .easeInOut) {
                viewBlur.layer.opacity = 1
                toView.alpha = 1
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

            let toView = transitionContext.viewController(forKey: .to)!.view!
            let blurView = toView.viewWithTag(123)
            let fromView = transitionContext.viewController(forKey: .from)!.view!

            let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), curve: .easeInOut) {
                blurView?.layer.opacity = 0
                fromView.alpha = 0
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
