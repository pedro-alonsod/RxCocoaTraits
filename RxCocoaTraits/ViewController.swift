//
//  ViewController.swift
//  RxCocoaTraits
//
//  Created by Pedro Alonso on 5/22/18.
//  Copyright © 2018 Pedro Alonso. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {

    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    @IBOutlet var demoTextField: UIView!
    @IBOutlet weak var demoTextArea: UITextView!
    @IBOutlet weak var demoTextLabel: UILabel!
    @IBOutlet weak var demoButton: UIButton!
    @IBOutlet weak var demoSegmentedView: UISegmentedControl!
    @IBOutlet weak var demoSlider: UISlider!
    @IBOutlet weak var demoProgressView: UIProgressView!
    @IBOutlet weak var demoSwitch: UISwitch!
    @IBOutlet weak var demoActivityView: UIActivityIndicatorView!
    @IBOutlet weak var demoStepper: UIStepper!
    @IBOutlet weak var demoStepperLabbel: UILabel!
    @IBOutlet weak var demoDatePicker: UIDatePicker!
    @IBOutlet weak var datePickerLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tapRecognizer.rx.event.debug()
        .subscribe(onNext: {
            [unowned self] event in
            self.view.endEditing(true)
        }, onError: { [unowned self] (error) in
            print(error)
        }, onCompleted: {
            print("Completed")
        }, onDisposed: {
            print("Disposing")
        }).disposed(by: disposeBag)
       
//        let demoTxtF:Observable = demoTextField.rx.text as! Observable
//        var text = demoTextField.rx.text
        
        self.demoTextField.rx.text
            .bind(to: demoTextLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.demoTextArea.rx.text.orEmpty.asDriver()
            .map{
                "Char count: \($0.count)"
            }
            .drive(demoTextLabel.rx.text)
            .disposed(by: disposeBag)
        
        demoButton.rx.tap
            .bind(onNext:{ [unowned self] _ in
                self.demoTextLabel.text! += "Tap clicked"
                self.view.endEditing(true)
                UIView.animate(withDuration:0.3){
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        demoSegmentedView.rx.value
            .skip(1)
            .bind(onNext: { [unowned self] in
                self.demoSegmentedView.text = "Selected Segment: \($0)"
                
                UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                })
            })
            .disposed(by:disposeBag)
        
        demoSlider.rx.value
            .bind(to: demoProgressView.rx.progress)
            .disposed(by: disposeBag)
        
        demoSwitch.rx.value
            .map { !$0 }
            .bind(to: demoActivityView.rx.isHidden)
            .disposed(by: disposeBag)
        
        demoSwitch.rx.value.asDriver()
            .drive(demoActivityView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        demoStepper.rx.value
            .map { String(Int($0))}
            .bind( to: demoStepperLabbel.rx.text)
            .disposed(by: disposeBag)
        
        demoDatePicker.rx.date
            .map{ [unowned self] in
            "Date picked: " + self.dateFormatter.string(from: $0)
            }
            .bind(to: datePickerLabel.rx.text)
            .disposed(by: disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

