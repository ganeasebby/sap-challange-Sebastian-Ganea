//
//  TestDataSource.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 25.07.2022.
//

import Foundation

class TestDataSourceFactory: DataSourceProtocol{
    /// returns an array of model that is used to populate the collectionview. Since this is the test datasource factory it will return a dummy array
    func getData() -> [SAPModel]{
        return generateDummyModels()
    }
    
    /// generates and returns a dummy array of models for testing purpose
    ///  - parameter modelsToCreate : How manny test models to create... by default 100
    func generateDummyModels(_ modelsToCreate: Int = 100) -> [SAPModel]{
        let textviewText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        
        var models = [SAPModel]()
        for i in 0 ... modelsToCreate - 1{
            // every 3rd model is a label model
            let position = i % 3
            
            if position == 0 {
                models.append(LabelModel(text: "Label"))
                
            }
            else{
                models.append(TextViewModel(text: textviewText))
            }
            
        }
        
        return models
    }
}
