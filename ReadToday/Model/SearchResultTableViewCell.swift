//
//  SearchResultTableViewCell.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 14/01/2021.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchResultImageView: UIImageView!
    @IBOutlet weak var searchResultTitleLabel: UILabel!
    @IBOutlet weak var searchResultAuthorLabel: UILabel!
    @IBOutlet weak var searchResultPagesLabel: UILabel!
    @IBOutlet weak var searchResultPublishLabel: UILabel!
    @IBOutlet weak var searchResultView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
