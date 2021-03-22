//
//  ViewController.swift
//  Practise2021
//
//  Created by Nand Parikh on 19/03/21.
//

import UIKit
import CoreData


class ViewController: UIViewController, UINavigationControllerDelegate {
    

    @IBOutlet weak var txtName : UITextField!
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var imgViewPicker : UIImageView!
    
    
    let defaults = UserDefaults.standard
    var personCounter : Int = 0
    
    //For Update Data
    var index = Int()
    var isUpdate = Bool()
    var dictUpdatedData = [String:Any]()
    
    
    //For ImagePicker
    var imagePicker = UIImagePickerController()
    var imageData : Data = Data()
    
    //MARK:- View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let testObj : Test = Test()
        print(testObj.printdata())
    }
    
    //MARK:- IB-Action Methods
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        
        if(txtName.text?.count == 0 || txtEmail.text?.count == 0){
            return
        }
        
        if !isUpdate {
            //Insert new data
            if (defaults.integer(forKey: "userId") != 0) {
                personCounter = defaults.integer(forKey: "userId")
            }else {
                personCounter = 1
            }
            
            let dictUser : [String:Any] =
                ["userId":"\(NSNumber(integerLiteral: personCounter))",
                 "name":txtName.text!,
                 "email":txtEmail.text!, "avatar" : self.imageData]
            DatabaseHelper.shareInstance.saveData(object: dictUser)
            
            personCounter = personCounter + 1
            defaults.setValue(personCounter, forKey: "userId")
            defaults.synchronize()
        }else{
            //Update existing data
            
            let dictUser : [String:Any] =
                ["userId":dictUpdatedData["userId"] as! String,
                 "name":txtName.text!,
                 "email":txtEmail.text!,
                 "avatar" : self.imageData
                ]

            DatabaseHelper.shareInstance.editData(object: dictUser, index: index)
        }
        
        self.clearTextFields()
        
    }
    
    @IBAction func btnFetchClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "goToListView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToListView" {
            let listVC = segue.destination as! ListViewController
            listVC.delegate = self
            listVC.strTitle = "Data From Segue"
        }
    }
    
//    If you not want to use segue then use this for going to next view conroller
//    func goToListVC() {
//        let listVC : ListViewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ListViewController") as? ListViewController)!
//        listVC.delegate = self
//        listVC.strTitle = "Data From Segue"
//        self.navigationController?.pushViewController(listVC, animated: true)
//    }
    
    func clearTextFields(){
        self.txtName.text = ""
        self.txtEmail.text = ""
        self.isUpdate = false
        self.imgViewPicker.image = UIImage(named: "placeholder")
        self.imgViewPicker.contentMode = .scaleAspectFit
        self.txtName.becomeFirstResponder()

    }
}

extension ViewController : DataPass {
    func data(object: [String : Any], index: Int, isEdit: Bool) {
        self.index = index
        self.isUpdate = isEdit
        self.dictUpdatedData = object

        self.txtName.text = object["name"] as? String
        self.txtEmail.text = object["email"] as? String
        self.imgViewPicker.image =  UIImage(data: object["avatar"] as! Data)
    }
}


//MARK:- JSON Parsing
extension ViewController {
    @IBAction func getJsonDataClicked(_ sender: UIButton) {
        
        var arrData1 = [WelcomeElement]()
        let url = URL(string: "https://restcountries.eu/rest/v2/all")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                if error == nil {
                    arrData1 = try JSONDecoder().decode([WelcomeElement].self, from: data!)
                    print(arrData1)
                    if let jsonString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                        print(jsonString)
                    }
                }
            }catch{
                
            }
        }.resume()
    }
}

extension ViewController : UIImagePickerControllerDelegate {
    
    
    @IBAction func btnUploadAvatarClicked(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let choosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        picker.dismiss(animated: true) { [self] in
            self.imgViewPicker.image = choosenImage
            self.imgViewPicker.contentMode = .scaleAspectFill
            self.imageData = choosenImage.pngData()!
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
//    @IBAction func btnUploadAvatarClicked(_ sender: UIButton) {
//
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
//            self.imagePicker.delegate = self
//            self.imagePicker.allowsEditing = true
//            present(self.imagePicker, animated: true, completion: nil)
//        }
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
//
//        guard let choosenImage : UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
//            return
//        }
//
//        picker.dismiss(animated: true) {
//            self.imgViewPicker.image = choosenImage
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
//    {
//
//    }

}
