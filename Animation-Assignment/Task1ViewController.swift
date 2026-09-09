//
//  Task1ViewController.swift
//  Animation-Assignment
//
//  Created by Omsai Mutyalwar on 08/09/26.
//
/*
 This view controller includes Task 1 solution.

 Problem statement 1

 Create a square view and an Animate button. When the button is tapped, use UIView.animate to
 move the square to a new position and increase its size. When the button is tapped again,
 animate the square back to its original position and size. Use parameters such as duration, delay
 and animation curve to configure the animation.
*/

import UIKit

class Task1ViewController: UIViewController {

    // Stores the expanded/collapsed state of the square view.
    private var isExpanded = false
    // Stores the constraints which will be modified during animation.
    private var topConstraint: NSLayoutConstraint!
    private var widthConstraint: NSLayoutConstraint!

    // MARK: - Views

    // Created the square view.
    private let squareView: UIView = {
        let squareView = UIView()
        squareView.translatesAutoresizingMaskIntoConstraints = false
        squareView.backgroundColor = .red
        return squareView
    }()

    // Created a animate button with required configuartion.
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

        setupViews()
        setupSquareViewConstraints()
    }

    // MARK: - Helper methods

    private func setupViews() {

        view.addSubview(squareView)
        view.addSubview(animateButton)

        animateButton.addTarget(self, action: #selector(performAction), for: .touchUpInside)

        NSLayoutConstraint.activate([
            animateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }

    private func setupSquareViewConstraints() {
        topConstraint = squareView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 400)
        widthConstraint = squareView.widthAnchor.constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            squareView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            squareView.heightAnchor.constraint(equalTo: squareView.widthAnchor),
            topConstraint,
            widthConstraint
        ])
    }

    // MARK: - Action methods

    @objc private func performAction() {
        // Toggle the isExpanded between expanded and collapsed states.
        isExpanded.toggle()

        // Change the existing constraint constants.
        topConstraint.constant = isExpanded ? 20 : 400
        widthConstraint.constant = isExpanded ? 200 : 50

        // Don't animate the change when reduce motion is enabled.
        if UIAccessibility.isReduceMotionEnabled {
            self.view.layoutIfNeeded()
            return
        }

        // Animate the constraint changes.
        UIView.animate(
            withDuration: 0.5,
            delay: 0.5,
            options: [.curveEaseInOut]
        ) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
