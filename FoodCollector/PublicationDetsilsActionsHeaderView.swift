//
//  PublicationDetsilsActionsHeaderView.swift
//  FoodCollector
//
//  Created by Guy Freedman on 6/8/15.
//  Copyright (c) 2015 Guy Freeman. All rights reserved.
//

import UIKit
import Foundation

protocol PublicationDetailsActionsHeaderDelegate: NSObjectProtocol {
    
    func didRegisterForPublication(publication: FCPublication)
    func didUnRegisterForPublication(publication: FCPublication)
    func didRequestNavigationForPublication(publication: FCPublication)
    func didRequestPhoneCallForPublication(publication: FCPublication)
    func didRequestSmsForPublication(publication: FCPublication)
}

class PublicationDetsilsActionsHeaderView: UIView {
    
    let buttonPressColor = UIColor(red: 32/255, green: 137/255, blue: 75/255, alpha: 1)
    let normalColor = kNavBarBlueColor
    let registeredButtonImage = UIImage(named: "rishum")!
    let unRegisteredButtonImage = UIImage(named: "CancelRishum")!
    
    @IBOutlet weak var button1to2widthConstraint : NSLayoutConstraint!
    @IBOutlet weak var button2to3widthConstraint : NSLayoutConstraint!
    @IBOutlet weak var button3to4widthConstraint : NSLayoutConstraint!


    
    @IBOutlet weak var registerButton:  UIButton!
    @IBOutlet weak var navigateButton:  UIButton!
    @IBOutlet weak var smsButton:       UIButton!
    @IBOutlet weak var phoneCallButton: UIButton!
    
    weak var delegate: PublicationDetailsActionsHeaderDelegate!
    
    var buttons = [UIButton]()
    
    var publication: FCPublication! {
        didSet {
            if let publication = self.publication {
                configureInitialState(publication)
            }
        }
    }
    

    
    @IBAction func buttonsActions (sender: UIButton!) {
    
        animateButton(sender)

        switch sender {

        case registerButton:

            
            if let delegate = self.delegate {
                switch self.publication.didRegisterForCurrentPublication {
                case true:
                    delegate.didUnRegisterForPublication(self.publication)
                case false:
                    delegate.didRegisterForPublication(self.publication)
                default:
                    break
                }
            }
            
        case navigateButton:
            
            if !self.publication.didRegisterForCurrentPublication {
                self.delegate.didRegisterForPublication(self.publication)
                if self.publication.typeOfCollecting == .ContactPublisher {return}
            }

            if let delegate = self.delegate {
                    delegate.didRequestNavigationForPublication(self.publication)
            }
            
        case smsButton:

            if let delegate = self.delegate {
                delegate.didRequestSmsForPublication(self.publication)
            }
            
        case phoneCallButton:

            if let delegate = self.delegate {
                delegate.didRequestPhoneCallForPublication(self.publication)
            }
            
        default:
            println("publication details unknown button")
        }
    }
    
    func configureInitialState(publication: FCPublication) {
        //User created publication
        if FCModel.sharedInstance.isUserCreaetedPublication(publication){
            self.disableAllButtons()
            return
        }
        
        configureButtonsForNormalState()
        configureRegisterButton()

        
        if publication.typeOfCollecting != .ContactPublisher {
    
            configureButtonsForFreePickup()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        buttons = [registerButton, navigateButton,smsButton, phoneCallButton]
        configureButtons()
    }
    
    func configureButtons() {
        
        for button in self.buttons {
            
            button.backgroundColor = normalColor
            button.setTitle("", forState: .Normal)
            button.layer.cornerRadius = CGRectGetWidth(button.frame) / 2
            button.enabled = true
        }
    }
        
    func disableAllButtons() {
        for button in self.buttons {
            
            let buttonColor = UIColor.lightGrayColor()
            button.backgroundColor = buttonColor
            button.enabled = false
        }
    }
    
    func configureButtonsForNormalState() {
     
        for button in self.buttons {
            
            button.backgroundColor = normalColor
            button.enabled = true
        }
    }
    
    private func configureButtonsForFreePickup() {
        
        let contactButtons = [smsButton , phoneCallButton]
        for button in contactButtons {
            
            let buttonColor = UIColor.lightGrayColor()
            button.backgroundColor = buttonColor
            button.enabled = false
        }
    }
    
    private func configureRegisterButton() {
        
        if let publication = publication {
            switch publication.didRegisterForCurrentPublication {
            case true:
                self.registerButton.backgroundColor = self.buttonPressColor
                self.registerButton.setImage(unRegisteredButtonImage, forState: .Normal)
                
            default :
                self.registerButton.backgroundColor = self.normalColor
                self.registerButton.setImage(registeredButtonImage, forState: UIControlState.Normal)
            }
        }
    }
    
    private func animateButton(button: UIButton) {
        
        let scale = CGAffineTransformMakeScale(1.2, 1.2)
        
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.8 , initialSpringVelocity: 0, options: nil, animations: { () -> Void in
            
            button.transform = scale
            button.backgroundColor = self.buttonPressColor

        }) { (finished) -> Void in
            
                UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                    
                    button.transform = CGAffineTransformIdentity
                    if button != self.registerButton {
                        button.backgroundColor = self.normalColor
                    }


                }) { (finished) -> Void in
                    
                    self.configureRegisterButton()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateButtonsConstraints()
    }
    
    private func updateButtonsConstraints() {

        let buttonTotalWidth: CGFloat = 230
        let viewWidth = FCDeviceData.screenWidth()
        let margin = floor((viewWidth - buttonTotalWidth) / 3)
        let middleMargin = viewWidth - buttonTotalWidth - 2*margin
        
        println("width: \(viewWidth)")
        println("margin: \(margin)")
        println("middle margin: \(middleMargin)")

        
        self.button1to2widthConstraint.constant = margin
        self.button2to3widthConstraint.constant = middleMargin
        self.button3to4widthConstraint.constant = margin
        self.layoutIfNeeded()
    }
    
}
