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
    
    func setupWithModel(_ viewModel: CustomCollectionViewCellViewModel){
        
        if viewModel.type == .label{
            titleLabel = UILabel()
            titleLabel?.textAlignment = .center
            titleLabel?.text = viewModel.text
            titleLabel?.backgroundColor = .white
            self.contentView.addSubview(titleLabel!)
        }
        else if viewModel.type == .textView{
            textview = UITextView()
            textview?.text = viewModel.text
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
        titleLabel = nil
        textview = nil
    }
}
