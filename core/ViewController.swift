//
//  ViewController.swift
//  core
//
//  Created by Lasha Tavberidze on 13.12.24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var field: UITextField!
    private let arrayLabel = UILabel()
    private var userInputs: [String] = []
    private let eraseButton = UIButton()
    private let stackView = UIStackView()
    private var letterButtons: [UIButton] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEraseButton()
        loadArraysFromStorage()
        setUpArrayShower()
        setUpStackView()
        setUpTouchToEndKeyboard()
    }
    
    @IBAction func editingDidEnd(_ sender: UITextField) {
        updateLabel()
    }
    private func setUpStackView() {
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        [eraseButton ,label, field, arrayLabel].forEach { stackView.addArrangedSubview($0) }
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    private func updateLabel() {
        guard let input = field.text?.trimmingCharacters(in: .whitespaces), !input.isEmpty else {
            return
        }
        label.text = input
        userInputs.append(input)
        UserStorage.shared.saveUserInput(userInputs)
        updateArrayLabel()
    }
    private func setUpTouchToEndKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    private func setUpEraseButton() {
        let width = 150
        let height = 80

        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)

                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("WWW", for: .normal)

                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                // add it to the buttons view
                view.addSubview(letterButton)

                // and also to our letterButtons array
                letterButtons.append(letterButton)
            }
        }
        eraseButton.setTitle("clear", for: .normal)
        eraseButton.translatesAutoresizingMaskIntoConstraints = false
        eraseButton.titleLabel?.font = .systemFont(ofSize: 20)
        eraseButton.setTitleColor(.red, for: .normal)
        eraseButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        view.addSubview(eraseButton)
        NSLayoutConstraint.activate([
            eraseButton.bottomAnchor.constraint(equalTo: label.topAnchor, constant: 5)
        ])
    }
    private func setUpArrayShower() {
        arrayLabel.numberOfLines = 0
        arrayLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arrayLabel)
        
        NSLayoutConstraint.activate([
            arrayLabel.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 8),
            arrayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            arrayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        updateArrayLabel()
    }
    private func loadArraysFromStorage() {
        userInputs = UserStorage.shared.loadUserInput() ?? []
    }
    private func updateArrayLabel() {
        arrayLabel.text = userInputs.joined(separator: "\n")
    }
    @objc func endEditing() {
        view.endEditing(true)
    }
    @objc func clear(){
        userInputs.removeAll()
        UserStorage.shared.eraseUserInput()
        updateArrayLabel()
    }
}
