//
//  TextViewContent.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 26.07.2022.
//

import Foundation
import UIKit

/// a custom textview, used to populate the textview cells
class TextViewContent: UITextView{
    init(text: String?){
        super.init(frame: .zero, textContainer: nil)
        
        self.text = text
        self.textAlignment = .center
        self.isEditable = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
