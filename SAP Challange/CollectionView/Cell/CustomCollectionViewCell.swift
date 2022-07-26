//
//  CustomCollectionViewCell.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 18.07.2022.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    private var content: UIView?
    
    func setupWithModel(_ viewModel: CustomCollectionViewCellViewModel){
        content = viewModel.getContent()
        self.contentView.addSubview(content!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        content?.frame = self.contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        content?.removeFromSuperview()
        content = nil
    }
}
