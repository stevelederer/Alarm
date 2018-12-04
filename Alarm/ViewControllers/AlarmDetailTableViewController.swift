//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Steve Lederer on 12/1/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    var alarmIsOn: Bool = true
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var enableButton: UIButton!
    @IBOutlet weak var buttonCell: UITableViewCell!
    
    var alarm: Alarm? {
        didSet {
            alarmIsOn = alarm?.enabled ?? true
            loadViewIfNeeded()
            self.title = "Edit Alarm"
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if alarm != nil {
            enableButton.layer.cornerRadius = enableButton.frame.size.height/2
        } else {
            enableButton.isHidden = true
            buttonCell.isHidden = true
            self.title = "New Alarm"
        }
    }
    
    private func updateViews() {
        guard let alarm = alarm else { return }
        timePicker.date = alarm.fireDate
        alarmNameTextField.text = alarm.name
        updateButton()
    }
    
    private func updateButton() {
        guard let alarm = alarm else { return }
        if alarm.enabled == true {
            enableButton.setTitle("Alarm is On", for: .normal)
            enableButton.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        } else {
            enableButton.setTitle("Alarm is Off", for: .normal)
            enableButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }

    @IBAction func enableButtonTapped(_ sender: UIButton) {
        guard let alarm = alarm else { return }
        if alarm.enabled == true {
            alarm.enabled = false
            updateButton()
        } else {
            alarm.enabled = true
            updateButton()
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, fireDate: timePicker.date, name: alarmNameTextField.text ?? "", enabled: alarm.enabled)
        } else {
            AlarmController.shared.addAlarm(fireDate: timePicker.date, name: alarmNameTextField.text ?? "", enabled: alarmIsOn)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
