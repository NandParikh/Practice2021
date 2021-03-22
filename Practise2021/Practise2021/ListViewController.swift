//
//  ListViewController.swift
//  Practise2021
//
//  Created by Nand Parikh on 19/03/21.
//

import UIKit

protocol DataPass {
    func data(object:[String:Any], index : Int, isEdit : Bool)
}

class ListViewController: UIViewController {

    var strTitle : String?
    var userData = [Users]()
    var delegate : DataPass!
    var isListView: Bool!
    
    @IBOutlet weak var tblListView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var clvUser: UICollectionView!
    @IBOutlet weak var btnListGrid: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tblListView.delegate = self
        tblListView.dataSource = self
        lblTitle.text = strTitle
        self.showListView()

        userData = DatabaseHelper.shareInstance.fetchData()
        print(userData.count)
        print(userData)
        print(userData[0].phoneNumber)
        print(userData[0].gender)
    }
    
    @IBAction func btnListGridClicked(_ sender: UIBarButtonItem) {
        
        if isListView {
            self.showListView()
        }else{
            self.showGridView()
        }
    }
    
    func showGridView(){
        isListView = true
        btnListGrid.title = "List"
        tblListView.isHidden = true
        clvUser.isHidden = false
    }
    
    func showListView(){
        isListView = false
        btnListGrid.title = "Grid"
        tblListView.isHidden = false
        clvUser.isHidden = true
    }
    
}

extension ListViewController : UITableViewDelegate,UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ListCell = (tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListCell)!

        cell.user = userData[indexPath.row]
        
        return cell
    }
    
    
    //Editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            userData = DatabaseHelper.shareInstance.deleteData(index: indexPath.row)
            self.tblListView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userData[indexPath.row]
        let dict = ["userId": user.userId!,"name": user.name!,"email": user.email!, "avatar" : user.avatar!] as [String : Any]
        delegate.data(object: dict , index: indexPath.row, isEdit: true)
        self.navigationController?.popViewController(animated: true)
    }
}


class  clvCell: UICollectionViewCell {
    
    override class func awakeFromNib() {
        
    }
    
    
}
extension ListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : clvCell = collectionView.dequeueReusableCell(withReuseIdentifier: "clvCell", for: indexPath) as! clvCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.orange
        }else {
            cell.backgroundColor = UIColor.green
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 20
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 20
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
  
        let hw : CGFloat = (collectionView.frame.size.width / 3) - 30
        return CGSize(width: hw, height: hw)

    }
    
    
}
