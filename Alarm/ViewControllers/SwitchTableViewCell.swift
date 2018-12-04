//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Steve Lederer on 12/1/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    var alarm: Alarm? { //Landing pad?
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        if let alarm = alarm {
            timeLabel.text = alarm.fireTimeAsString
            nameLabel.text = alarm.name
            UIView.animate(withDuration: 0.2) {
                self.alarmSwitch.isOn = alarm.enabled
//                self.alarmSwitch.setOn(alarm.enabled, animated: true)
            }
        }
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        if let delegate = delegate {
            delegate.switchCellSwitchValueChanged(cell: self)
        }
    }
}
