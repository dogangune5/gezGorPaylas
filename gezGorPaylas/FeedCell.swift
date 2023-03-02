//
//  FeedCell.swift
//  gezGorPaylas
//
//  Created by doğan güneş on 1.03.2023.
//

import UIKit

class FeedCell: UITableViewCell {
    
    
    @IBOutlet weak var lblemail: UILabel!
    
    @IBOutlet weak var lblyorum: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    
    
    
    // başladığında ne olucak
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    // seçildiğinde ne olucak
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
