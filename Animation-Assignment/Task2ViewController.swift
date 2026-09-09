//
//  Task2ViewController.swift
//  Animation-Assignment
//
//  Created by Omsai Mutyalwar on 08/09/26.
//

/*
 This is the view controller for Task 2.

 Problem statement 2:

 Create a bouncing ball animation using CAKeyframeAnimation, where the ball follows
 a curved path and gradually settles back to its original position.
 */

import UIKit

class Task2ViewController: UIViewController {
    // We will store the initial original position of bouncing ball.
    private var originalPosition: CGPoint = .zero

    // MARK: - Views

    private let ballLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.red.withAlphaComponent(0.8).cgColor
        layer.cornerRadius = 20.0
        layer.frame = CGRect(x: 50, y: 250, width: 40, height: 40)
        return layer
    }()

    private let animateButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Animate"
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .systemBlue
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        let button = UIButton(configuration: config)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        originalPosition = ballLayer.position
        setupViews()
    }

    // MARK: - Helper methods

    private func setupViews() {
        view.layer.addSublayer(ballLayer)

        animateButton.addTarget(self, action: #selector(animateButtonTapped), for: .touchUpInside)
        view.addSubview(animateButton)

        NSLayoutConstraint.activate([
            animateButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            animateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }

    // MARK: - Action method

    @objc private func animateButtonTapped() {
        // Prevents another animation adding while other is running.
        guard ballLayer.animation(forKey: "bounce") == nil else {
            return
        }

        let animation = pathForBounceAnimation()
        ballLayer.add(animation, forKey: "bounce")
    }

    private func pathForBounceAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "position")
        let path = UIBezierPath()

        // It starts from the original position.
        path.move(to: originalPosition)

        // Adding the First bounce.
        path.addCurve(
            to: CGPoint(
                x: originalPosition.x + 50,
                y: originalPosition.y - 200
            ),
            controlPoint1: CGPoint(
                x: originalPosition.x + 15,
                y: originalPosition.y - 80
            ),
            controlPoint2: CGPoint(
                x: originalPosition.x + 40,
                y: originalPosition.y - 180
            )
        )

        path.addCurve(
            to: CGPoint(
                x: originalPosition.x + 100,
                y: originalPosition.y
            ),
            controlPoint1: CGPoint(
                x: originalPosition.x + 60,
                y: originalPosition.y - 180
            ),
            controlPoint2: CGPoint(
                x: originalPosition.x + 95,
                y: originalPosition.y - 30
            )
        )

        // Adding the Second bounce.
        path.addCurve(
            to: CGPoint(
                x: originalPosition.x + 150,
                y: originalPosition.y - 120
            ),
            controlPoint1: CGPoint(
                x: originalPosition.x + 115,
                y: originalPosition.y - 60
            ),
            controlPoint2: CGPoint(
                x: originalPosition.x + 140,
                y: originalPosition.y - 100
            )
        )

        path.addCurve(
            to: CGPoint(
                x: originalPosition.x + 200,
                y: originalPosition.y
            ),
            controlPoint1: CGPoint(
                x: originalPosition.x + 160,
                y: originalPosition.y - 100
            ),
            controlPoint2: CGPoint(
                x: originalPosition.x + 195,
                y: originalPosition.y - 25
            )
        )

        // Adding the Third bounce.
        path.addCurve(
            to: CGPoint(
                x: originalPosition.x + 240,
                y: originalPosition.y - 60
            ),
            controlPoint1: CGPoint(
                x: originalPosition.x + 205,
                y: originalPosition.y - 30
            ),
            controlPoint2: CGPoint(
                x: originalPosition.x + 230,
                y: originalPosition.y - 50
            )
        )

        path.addCurve(
            to: CGPoint(
                x: originalPosition.x + 270,
                y: originalPosition.y
            ),
            controlPoint1: CGPoint(
                x: originalPosition.x + 250,
                y: originalPosition.y - 50
            ),
            controlPoint2: CGPoint(
                x: originalPosition.x + 265,
                y: originalPosition.y - 10
            )
        )

        // Adding the final bounce.
        path.addCurve(
            to: CGPoint(
                x: originalPosition.x + 285,
                y: originalPosition.y - 25
            ),
            controlPoint1: CGPoint(
                x: originalPosition.x + 275,
                y: originalPosition.y - 15
            ),
            controlPoint2: CGPoint(
                x: originalPosition.x + 280,
                y: originalPosition.y - 25
            )
        )

        // Returning and settling at the original position.
        path.addCurve(
            to: originalPosition,
            controlPoint1: CGPoint(
                x: originalPosition.x + 290,
                y: originalPosition.y - 15
            ),
            controlPoint2: CGPoint(
                x: originalPosition.x + 20,
                y: originalPosition.y
            )
        )

        animation.path = path.cgPath
        animation.duration = 4.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }
}
