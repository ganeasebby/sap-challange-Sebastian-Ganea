//
//  CellContentViews.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 26.07.2022.
//

import Foundation
import UIKit

/// a custom label, used to populate the label cells
class LabelContent: UILabel{
    init(text: String?){
        super.init(frame: .zero)
        
        self.text = text
        self.textAlignment = .center
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


