//
//  AlphaTransition.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 20.02.2022.
//

import UIKit

final class AlphaTransition: NSObject, UIViewControllerAnimatedTransitioning {

    let isPresenting: Bool
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        let duration = self.transitionDuration(using: transitionContext)
        if isPresenting {
            transitionContext.containerView.addSubview(toViewController.view)
            transitionContext.containerView.alpha = 0
            toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
            toViewController.view.frame = CGRect(x: 0.0,
                                                 y: toViewController.view.frame.size.height,
                                                 width: toViewController.view.frame.size.width,
                                                 height: toViewController.view.frame.size.height)
        }

        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let self = self else { return }
            if self.isPresenting {
                transitionContext.containerView.alpha = 1
                transitionContext.containerView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)

                toViewController.view.frame = CGRect(x: 0.0,
                                                     y: 0.0,
                                                     width: toViewController.view.frame.size.width,
                                                     height: toViewController.view.frame.size.height)

            } else {
                fromViewController.view.frame = CGRect(x: 0.0,
                                                     y: toViewController.view.frame.size.height,
                                                     width: toViewController.view.frame.size.width,
                                                     height: toViewController.view.frame.size.height)
                transitionContext.containerView.alpha = 0
            }
        }, completion: { _ in
            if !self.isPresenting {
                fromViewController.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

}
