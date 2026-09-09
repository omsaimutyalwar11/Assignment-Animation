//
//  ViewController.swift
//  Animation-Assignment
//
//  Created by Omsai Mutyalwar on 08/09/26.
//

import UIKit

class ViewController: UIViewController {

    let tasksView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.backgroundColor = .lightGray
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    // MARK: - Helper methods

    private func setupViews() {
        let button1 = createButton(title: "Task 1")
        button1.addTarget(self, action: #selector(performActionTask1), for: .touchUpInside)

        let button2 = createButton(title: "Task 2")
        button2.addTarget(self, action: #selector(performActionTask2), for: .touchUpInside)

        let button3 = createButton(title: "Task 3")
        button3.addTarget(self, action: #selector(performActionTask3), for: .touchUpInside)

        tasksView.addArrangedSubview(button1)
        tasksView.addArrangedSubview(button2)
        tasksView.addArrangedSubview(button3)
        view.addSubview(tasksView)

        NSLayoutConstraint.activate([
            tasksView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            tasksView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            tasksView.widthAnchor.constraint(equalToConstant: 250)
        ])
    }

    private func createButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }

    @objc private func performActionTask1() {
        let task1ViewController = Task1ViewController()
        task1ViewController.modalPresentationStyle = .fullScreen
        present(task1ViewController, animated: true)
    }

    @objc private func performActionTask2() {
        let task2ViewController = Task2ViewController()
        task2ViewController.modalPresentationStyle = .fullScreen
        present(task2ViewController, animated: true)
    }

    @objc private func performActionTask3() {
        let task3ViewController = Task3ViewController()
        task3ViewController.modalPresentationStyle = .fullScreen
        present(task3ViewController, animated: true)
    }
}

