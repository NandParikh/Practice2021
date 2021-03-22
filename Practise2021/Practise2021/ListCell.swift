//
//  ListCell.swift
//  Practise2021
//
//  Created by Nand Parikh on 19/03/21.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewContainer : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        imgProfile.layer.borderColor = UIColor.black.cgColor
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.masksToBounds = true
        imgProfile.clipsToBounds = true
        imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2
        
        viewContainer.layer.shadowOpacity = 0.8
        viewContainer.layer.shadowOffset = CGSize.zero
        viewContainer.layer.shadowRadius = 3
        viewContainer.layer.cornerRadius = viewContainer.frame.size.width / 2
        viewContainer.layer.shadowPath = UIBezierPath(roundedRect: viewContainer.bounds, cornerRadius: viewContainer.frame.size.width / 2).cgPath

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var user:Users! {
        didSet{
            lblID.text = user.userId
            lblName.text = user.name
            lblEmail.text = user.email
            imgProfile.image = UIImage(data: user.avatar!)
        }
    }


}
