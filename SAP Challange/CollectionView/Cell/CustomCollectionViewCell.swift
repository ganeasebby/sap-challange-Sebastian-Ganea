//
//  CustomCollectionViewCell.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 18.07.2022.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    private var titleLabel: UILabel?
    private var textview: UITextView?
    
    func setupWithModel(_ model: CustomCollectionViewCellViewModel){
        if model.titleString != nil{
            titleLabel = UILabel()
            titleLabel?.textAlignment = .center
            titleLabel?.text = model.titleString
            titleLabel?.backgroundColor = .white
            self.contentView.addSubview(titleLabel!)
        }
        else if model.descriptionString != nil{
            textview = UITextView()
            textview?.text = model.descriptionString
            textview?.textAlignment = .center
            textview?.isEditable = false
            self.contentView.addSubview(textview!)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame = self.contentView.bounds
        textview?.frame = self.contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.subviews.forEach({$0.removeFromSuperview()})
    }
}
