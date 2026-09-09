//
//  Task3ViewController.swift
//  Animation-Assignment
//
//  Created by Omsai Mutyalwar on 09/09/26.
//

/*
 This is the view controller for Task 3.

 Problem statement 3:

 Create a view and animate it using UIViewPropertyAnimator. Add controls to start, pause, resume
 and reverse the animation. The animation should be controllable while it is running.
 */
import UIKit

class Task3ViewController: UIViewController {

    // MARK: - Views

    private let startButton = createButton(title: "Start")
    private let pauseButton = createButton(title: "Pause")
    private let resumeButton = createButton(title: "Resume")
    private let reverseButton = createButton(title: "Reverse")

    private let buttonView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // Create a view which we will be going to animate.
    private let squareView = UIView(frame: CGRect(x: 0, y: 100, width: 50, height: 50))

    // Create a UIViewPropertyAnimator with basic config.
    let animator = UIViewPropertyAnimator(duration: 5.0, dampingRatio: 0.5)
    // Create a UIViewPropertyAnimator to control swipe gesture.
    var horizontalAnimator: UIViewPropertyAnimator!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupButtonView()
        setupSquareView()
        addAnimation()

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGestureRecognizer)
    }

    private func setupButtonView() {
        startButton.addTarget(self, action: #selector(startAnimation), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseAnimation), for: .touchUpInside)
        resumeButton.addTarget(self, action: #selector(resumeAnimation), for: .touchUpInside)
        reverseButton.addTarget(self, action: #selector(reverseAnimation), for: .touchUpInside)

        view.addSubview(buttonView)
        buttonView.addArrangedSubview(startButton)
        buttonView.addArrangedSubview(pauseButton)
        buttonView.addArrangedSubview(resumeButton)
        buttonView.addArrangedSubview(reverseButton)

        NSLayoutConstraint.activate([
            buttonView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            buttonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func setupSquareView() {
        squareView.backgroundColor = .red
        squareView.center.x = view.center.x
        view.addSubview(squareView)
    }

    private func addAnimation() {
        animator.addAnimations { [weak self] in
            guard let self else {
                return
            }
            self.squareView.center.y += 450
            self.squareView.backgroundColor = .systemBlue
        }
    }

    private static func createButton(title: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .systemBlue
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        let button = UIButton(configuration: config)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    // MARK: - Action Methods for buttons

    @objc private func startAnimation() {
        // Used the below condition because clicking pauseAnimation() and then startAnimation()
        // caused the app to crash. This condition helps prevent the crash.
        if animator.state == .inactive {
            animator.startAnimation(afterDelay: 0.3)
        }
    }

    @objc private func pauseAnimation() {
        if (animator.isRunning) {
            animator.pauseAnimation()
        }
    }

    @objc private func resumeAnimation() {
        animator.continueAnimation(withTimingParameters: UICubicTimingParameters(animationCurve: .easeInOut), durationFactor: 0.5)
    }

    @objc private func reverseAnimation() {
        animator.isReversed.toggle()
    }

    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        switch gestureRecognizer.state {
        case .began:
            let velocityX = gestureRecognizer.velocity(in: view).x
            horizontalAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) { [weak self] in
                guard let self else {
                    return
                }

                if velocityX > 0 {
                    self.squareView.center.x += 100
                } else {
                    self.squareView.center.x -= 100
                }
            }

            horizontalAnimator?.startAnimation()
            horizontalAnimator?.pauseAnimation()
        case .changed:
            let progress = translation.x / view.bounds.width
            horizontalAnimator?.fractionComplete = progress
        case .ended, .cancelled:
            horizontalAnimator?.continueAnimation(
                withTimingParameters: nil,
                durationFactor: 0
            )
        default:
            break
        }
    }
}
