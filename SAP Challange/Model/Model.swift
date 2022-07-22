//
//  DataSourceModel.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 18.07.2022.
//

import Foundation
import UIKit

protocol SAPModel{
    var titleStr: String? { get set }
    var textviewStr: String? { get set }
}
extension SAPModel{
    var textviewStr: String? { return nil }
}


struct LabelModel: SAPModel {
    var titleStr: String?
    var textviewStr: String?
}

struct TextViewModel: SAPModel{
    var titleStr: String?
    var textviewStr: String?
}
