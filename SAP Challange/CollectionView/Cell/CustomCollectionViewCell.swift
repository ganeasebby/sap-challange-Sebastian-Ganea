//
//  CustomCollectionViewCell.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 18.07.2022.
//

import UIKit

/// a custom cell used to display our content
class CustomCollectionViewCell: UICollectionViewCell {
    private var content: UIView?
    
    /// sets up the content of the cell based on the viewmodel
    func setupWithModel(_ viewModel: CustomCollectionViewCellViewModel){
        content = viewModel.getContent()
        self.contentView.addSubview(content!)
    }
    
    /// updates the layout of all subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        content?.frame = self.contentView.bounds
    }
    
    /// prepares the cell for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        content?.removeFromSuperview()
        content = nil
    }
}
