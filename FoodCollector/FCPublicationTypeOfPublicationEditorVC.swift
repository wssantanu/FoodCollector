//
//  FCPublicationTypeOfPublicationEditorVC.swift
//  FoodCollector
//
//  Created by Boris Tsigelman on 28/12/14.
//  Copyright (c) 2014 Guy Freeman. All rights reserved.
//

import UIKit

let kTypeOfCollectingFreePickUpTitle =
String.localizedStringWithFormat("איסוף חופשי", "the type of collecting method meaning free pickup")

let kTypeOfCollectingContactPublisherTitle =
String.localizedStringWithFormat("צור קשר עם המפרסם", "the type of collecting method meaning call publisher")

let typeOfCollectionEditorTitle = String.localizedStringWithFormat("צורת איסוף", "the editor title for enter type of collecting")

class FCPublicationTypeOfPublicationEditorVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionTypePicker: UIPickerView!
    
    var cellData = FCPublicationEditorTVCCellData()
    let digits = "0123456789"
    
    
    let pickerData = [kTypeOfCollectingFreePickUpTitle , kTypeOfCollectingContactPublisherTitle]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        self.textField.alpha = 0
        self.textField.text = ""
        self.title = typeOfCollectionEditorTitle
        configureInitialState()
    }
    
    func configureInitialState() {
        
        if cellData.containsUserData {
          
            let typeOfCollectingDict = cellData.userData as [String : AnyObject]
            let aRawValue = typeOfCollectingDict[kPublicationTypeOfCollectingKey] as Int
            let typeOfcollecting = FCTypeOfCollecting(rawValue: aRawValue)
            if typeOfcollecting == FCTypeOfCollecting.ContactPublisher {
                
                let phoneNumber = typeOfCollectingDict[kPublicationContactInfoKey] as String
                self.textField.text = phoneNumber
                showContactDetailsViews()
                self.collectionTypePicker.selectRow(1, inComponent: 0, animated: true)
            }
        }
    }
    
    @IBAction func saveButtonAction(sender: AnyObject) {
        
        let unwindSegueId = "unwindFromTypeOfCollectionEditorVC"
        let userChosenTypeOfCollectin = self.collectionTypePicker.selectedRowInComponent(0) + 1
        let typeOfCollecting = FCTypeOfCollecting(rawValue: userChosenTypeOfCollectin)!
        var contactInfo = ""
        if userChosenTypeOfCollectin == 1 {contactInfo = "no"}
        else {contactInfo = self.textField.text}
        var typeOfCollectingDict: [String : AnyObject] = [kPublicationTypeOfCollectingKey : userChosenTypeOfCollectin , kPublicationContactInfoKey : contactInfo]
        
        var cellTitle = ""
        
        switch typeOfCollecting {
       
        case .FreePickUp:
            cellTitle = kTypeOfCollectingFreePickUpTitle
        case .ContactPublisher:
            var callString = String.localizedStringWithFormat("התקשר: ", "means call to be added before a phone number")
            cellTitle = "\(callString) \(self.textField.text)"
        }
        
        self.cellData.containsUserData = true
        self.cellData.userData = typeOfCollectingDict
        self.cellData.cellTitle = cellTitle

        //here I can check if the number is valid
        self.performSegueWithIdentifier(unwindSegueId, sender: self)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        switch row {
        case 0:
            hideContactDetailsViews()
        
        case 1:
            showContactDetailsViews()
        default:
            break
        }
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("picker view did select row")
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text as NSString).length + (string as NSString).length - range.length
        
        let digitsCharecterSet = NSCharacterSet(charactersInString: digits).invertedSet
        
        let components = string.componentsSeparatedByCharactersInSet(digitsCharecterSet)
        
        let filtered = join("", components)
        
        return string == filtered && newLength <= 10
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hideContactDetailsViews() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.textField.alpha = 0
        })
    }
    
    func showContactDetailsViews() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.textField.alpha = 1
        })
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.textField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
}
