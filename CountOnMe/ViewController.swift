//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "X"
        
    }
    
    var canAddComma: Bool {
        return elements.count == 0 || !elements.last!.contains(".")
    }

    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal)else {
            return
        }
        addDigit(digit: numberText)
    }
    
    @IBAction func tappedACButton(_ sender: UIButton) {
            textView.text = ""
    }
    func addOperand(operand: String){
        if expressionHaveResult {
            var last = textView.text.split(separator: "=").map { "\($0)" }
            textView.text = last.last  
          }
        textView.text.append(operand)
    }
    func addDigit(digit: String){
        if expressionHaveResult {
                textView.text = ""
        }
        textView.text.append(digit)
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if canAddOperator {
            addOperand(operand: " + ")
        }
         else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedCommaButton(_ sender: UIButton) {
        if canAddComma {
            if textView.text.last == " " || textView.text == "" || expressionHaveResult{
                addDigit(digit: "0.")
            }else{
                addDigit(digit: ".")
            }
        }
        else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Une virgule est déja mise !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if canAddOperator {
            addOperand(operand: " - ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        if canAddOperator {
            addOperand(operand: " / ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        if canAddOperator {
            addOperand(operand: " x ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard expressionIsCorrect else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Entrez une expression correcte !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        
        guard expressionHaveEnoughElement else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        if expressionHaveResult{
            return 
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        operationsToReduce = doOperation(operationsToReduce: &operationsToReduce,operand:"x")
        operationsToReduce = doOperation(operationsToReduce: &operationsToReduce,operand:"/")
        operationsToReduce = doOperation(operationsToReduce: &operationsToReduce,operand:"+")
        operationsToReduce = doOperation(operationsToReduce: &operationsToReduce,operand:"-")
        var result = Double(operationsToReduce.first!)!
        var something = String(result)
        if result - floor(result) == 0 {
            something = String(Int(floor(result)))
        }
        textView.text.append(" = \(something)")
    }
    func doOperation(operationsToReduce: inout [String],operand:String) -> [String]{
        var havex = true 
        while havex{
            havex = false
            for index in 0...operationsToReduce.count-1{
                if operationsToReduce[index] == operand {
                    let left = Double(operationsToReduce[index-1])!
                    let right = Double(operationsToReduce[index+1])!
                    let result: Double
                    switch operand {
                    case "+": result = left + right
                    case "-": result = left - right
                    case "x": result = left * right
                    case "/": result = left / right
                    default: fatalError("Unknown operator !")
                    }
                    operationsToReduce.remove(at: index+1)
                    operationsToReduce.remove(at: index)
                    operationsToReduce[index-1]="\(result)"
                    havex = true
                    break
                }
            }
        }

            return operationsToReduce

        
    }

}

