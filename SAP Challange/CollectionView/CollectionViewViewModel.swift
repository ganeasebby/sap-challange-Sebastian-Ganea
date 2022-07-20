//
//  CollectionViewViewModel.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 18.07.2022.
//

import UIKit

class CollectionViewViewModel {
    
    /// a structure that is used to populate the collectionview. It combines the model(Planet) and the cell calcuclated size
    struct DatasourceObject{
        let planet: Planet
        var cellSize: CGSize
    }
    
    /// The possible ways the user can perform a pinch gesture with two fingers.
    enum GestureType{
        case horizontal
        case vertical
        case diagonal
    }
    
    /// this is the datasource we use to populate the collectionview
    var datasource: [DatasourceObject]!
    
    /// The total ammount of cells the collectionview will display horrizontally
    let nrOfCellsInRow = 3
    
    /// the space between cells
    let cellPadding: CGFloat = 2
    
    /// the width of the collectionview. Is set at the initialization of the view model
    private var collectionviewWidth: CGFloat!
    
    /// the maximum width that a cell can have.
    private var maxCellWidth: CGFloat!
    
    /// the minimum cell width.  Setting it lower then 50 can make cells harder to pinch, when they are at minimum size
    private var minCellWidth: CGFloat = 50
    
    /// the default cell size. The cells size is calculated so that enought cells(defined by "nrOfCellsInRow") fit horizontally on the collectionview
    private var defaultCellSize: CGSize!
    
    /// this is the size of the cell that the user is currently interacting(pinching) with
    private var focusedCellSize: CGSize?
    
    /// this is the ammount of scale applied on the width of the cell, while the user interacts with it
    private var horScale: CGFloat = 1
    
    /// this is the ammount of scale applied on the height of the cell, while the user interacts with it
    private var vertSacle: CGFloat = 1
    
    /// we deffined three possible types of pinch. While the user interacts(pinch) with a cell he can only do a horizontal, vertical, diagonal pinch.  Which will scale the cell horizontally, vertically or both
    private var pinchType: GestureType!
    
    
    init(collectionView: UICollectionView){
        updateCollectionviewWidth(collectionView.frame.width)
    }
    
    /// generates a dummy datasource
    private func createDataSource() -> [DatasourceObject]{
        var dummy = [DatasourceObject]()
        let dummyDescription = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        for i in 1 ... 200{
            let planet = Planet(title: "Planet \(i)", description: dummyDescription)
            let dataSourceObj = DatasourceObject(planet: planet, cellSize: defaultCellSize)
            dummy.append(dataSourceObj)
        }
        
        return dummy
    }
    
    
    
    //MARK: - Layout
    func updateCollectionviewWidth(_ newWidth: CGFloat){
        collectionviewWidth = newWidth
        self.maxCellWidth = calculateMaxCellWidth()
        self.defaultCellSize = calculateDefaultCellSize()
        datasource = createDataSource()
    }
    /// calculates and returns the initial size for cells. The size of the cells is maximized so that enough cells will fit in one row(nrOfCellsInRow).
    func calculateDefaultCellSize() -> CGSize{
        let spaceBetweenCells = (CGFloat(nrOfCellsInRow) + 1) * cellPadding
        let cellWidth = (collectionviewWidth - spaceBetweenCells) / CGFloat(nrOfCellsInRow)
        
        return CGSize(width: floor(cellWidth), height: floor(cellWidth))
    }
    
    /// calculates and returns the maximum width that a cell can have. We need this because we have a fixed number of cells that must fit horizontally on a row. And whenever we increase the size of one cell the others will shrink is size, and we don't want the shrinked cells to be to small in size.
    func calculateMaxCellWidth() -> CGFloat{
        let cells = CGFloat(nrOfCellsInRow)
        let totalSpaceBetweenCells = (cells + 1) * cellPadding
        let result = collectionviewWidth - (minCellWidth * cells + totalSpaceBetweenCells)
        return result
    }
    
    
    /// this function will update the size for all cells in the data source.First it will set the size for the cell that the user interacted with, and then it will update the size for the rest of the cells so that they don't break the originalgrid layout
    ///
    ///  - Parameter indexPath: The indexpath of the cell that the user is interacting(pinch) with.
    ///  - Parameter size: The new size which cell at the `indexPath` will have
    func setSizeForCellAt(indexPath: IndexPath, size: CGSize){
        /// this is the position in row that the cell with which the user interacted is. For example in a row that has 3 cells the `focusedCellPosition` can be 0, 1 or 2
        let focusedCellPosition = getPositionInRowFor(indexPath: indexPath)
        
        // First we make sure that the new size is valid
        let originalSizeForFocusedCell = datasource[indexPath.row].cellSize
        var sizeForFocusedCell = size
        if sizeForFocusedCell.width > maxCellWidth{
            sizeForFocusedCell.width = maxCellWidth
        }
        if sizeForFocusedCell.width < minCellWidth{
            sizeForFocusedCell.width = minCellWidth
        }
        
        
        // Next we update the height for all cells that are on the same row with the cell that the user interacts with. We only need to update the height on this row according to the requrements (and example given)
        // We also define an array that holds the width of every cell in a row
        /// the array holds the width of every cell in one row. So at index 0 we have the width for the first cell, at index 1 the width of cell 2...etc
        var rowWidthSizes = [CGFloat]()
        let rowStart = indexPath.row - focusedCellPosition
        var rowEnd = rowStart + nrOfCellsInRow - 1
        if rowEnd >= datasource.count {
            rowEnd = datasource.count - 1
        }
        for i in rowStart ... rowEnd{
            guard datasource.count >= i else {break}
            datasource[i].cellSize.height = sizeForFocusedCell.height
            rowWidthSizes.append(datasource[i].cellSize.width)
        }
        
        // Next we find out by how much the cells width will change
        /// this is the total space by which the user interacted cell is changed (increased or decreased)
        var totalSpace = originalSizeForFocusedCell.width - sizeForFocusedCell.width
        
        /// this is the space by which each indivitual cell in a row needs to increase or decrease
        let spacePerCellChange = totalSpace / ( CGFloat(nrOfCellsInRow) - 1)
        
        // Next we need to actually change the width for every cell in a row, so that we don't break the grid layout... Meaning, we actually need to change the rest of the cells width in the row, by the ammount of that whe changed that the user increased/decreased the cell.
        // we start a while loop in which we add/subtract space to each item in `rowWidthSizes`.
        var idx = -1
        while totalSpace != 0 {
            idx = (idx + 1 == rowWidthSizes.count) ? 0 : idx + 1
            
            // we skip this item because it's the cell that the user pinched
            guard focusedCellPosition != idx else {continue}
            
            let crtCellWidth = rowWidthSizes[idx]
            // this is the maximum ammount of space that we need to add or subtract from this cell
            let changeAmmount = (abs(spacePerCellChange) > abs(totalSpace)) ? totalSpace : spacePerCellChange
            
            // we check if the cell is allowed to grow or shrink by this ammount
            let newWidth = crtCellWidth + changeAmmount
            
            if newWidth > maxCellWidth{
                // looks like the cell will be bigger then the allowed size... we increase the size to maximum allowed
                rowWidthSizes[idx] = maxCellWidth
                // we remove from the total space the ammount of space we added to this cell
                totalSpace -= maxCellWidth - crtCellWidth
                continue
            }
            else if newWidth < minCellWidth{
                // looks like the cell will be smaller then the allowed size... we decrease the size to maximum allowed
                rowWidthSizes[idx] = minCellWidth
                // we remove from the total space the ammount of space we added to this cell
                totalSpace -= minCellWidth - crtCellWidth
                continue
            }
            else{
                
                totalSpace -= changeAmmount
                rowWidthSizes[idx] = newWidth
            }
            
            
        }
        
        // after the loop is done, we set the width for the cell that the user interacted with
        rowWidthSizes[focusedCellPosition] = sizeForFocusedCell.width
        
        
        print("total = \(collectionviewWidth!)")
        print("minCell = \(minCellWidth)")
        print("max = \(maxCellWidth!)")
        print("\(rowWidthSizes[0]) + \(rowWidthSizes[1]) + \(rowWidthSizes[2]) + \((CGFloat(nrOfCellsInRow) + 1) * cellPadding)) = \(rowWidthSizes[0] + rowWidthSizes[1] + rowWidthSizes[2] + ((CGFloat(nrOfCellsInRow) + 1) * cellPadding))")
        
        // And finally we update every cell width in the datasource, using the sizes we defind in `rowWidthSizes`
        for index in 0 ... datasource.count - 1{
            let rowPosition = index % nrOfCellsInRow
            datasource[index].cellSize.width = rowWidthSizes[rowPosition]
        }
        
    }
    
    
    //MARK: - Helpers
    /// returns the row position of a cell at a specific index path. For example if the collectionview has 3 cells in a row, the idx 0,1 or 2 will return position 0,1 or 2 but idx 3 will return position 0 since it's the first cell on the second row
    private func getPositionInRowFor(indexPath: IndexPath) -> Int{
        let result = indexPath.row % nrOfCellsInRow
        return result
    }
    
    /// this function will calculate the new size for the cell which the user interacts with. The size is changed on different axes based on the gesture. The gesture is devided in three types: horizontal(will only change the width), vertical(will only change the height), diagonal(will change both)
    func calculateSizeFor(pinchGesture: UIPinchGestureRecognizer) -> CGSize?{
        // we need at least 2 points to calculate the angle
        guard pinchGesture.numberOfTouches > 1 else {return nil}
        let locationOne = pinchGesture.location(ofTouch: 0, in: pinchGesture.view)
        let locationTwo = pinchGesture.location(ofTouch: 1, in: pinchGesture.view)
        let diffX = locationOne.x - locationTwo.x
        let diffY = locationOne.y - locationTwo.y
        
        /// the angle of the gesture
        let bearingAngle = diffY == 0 ? CGFloat.pi / 2.0 : abs(atan(diffX/diffY))
        
        if bearingAngle < CGFloat.pi / 6.0 {
            // vertical
            pinchType = .vertical
        }
        else if bearingAngle < CGFloat.pi / 3.0 {
            // diagonal
            pinchType = .diagonal
        }
        else if bearingAngle <= CGFloat.pi / 2.0 {
            // horizontal
            pinchType = .horizontal
        }

        if pinchGesture.state == .began{
            // at the beggining of the gesture we store the original size of the cell and we reset any scale that we previously set
            focusedCellSize = pinchGesture.view?.frame.size
            horScale = 1
            vertSacle = 1
        }
        else if pinchGesture.state == .changed{
            // during the change we apply the scale on width/height depending on the gesture type
            guard let size = focusedCellSize else {return nil}
            switch pinchType{
            case .horizontal:
                horScale = pinchGesture.scale
                var width = size.width * horScale
                if width > maxCellWidth{
                    width = maxCellWidth
                }
                return CGSize(width: width, height: size.height * vertSacle)
            case .vertical:
                vertSacle = pinchGesture.scale
                var width = size.width * horScale
                if width > maxCellWidth{
                    width = maxCellWidth
                }
                return CGSize(width: width, height: size.height * vertSacle)
            case .diagonal:
                horScale = pinchGesture.scale
                vertSacle = pinchGesture.scale
                var width = size.width * horScale
                if width > maxCellWidth{
                    width = maxCellWidth
                }
                return CGSize(width: width, height: size.height * vertSacle)
            case .none: return nil
            }
        }
        
        
        return nil
    }
    
    func getCellModel(indexPath: IndexPath) -> CustomCollectionViewCellViewModel{
        if getPositionInRowFor(indexPath: indexPath) == 0{
            // first cells in row have labels
            let label = UILabel()
            label.text = datasource[indexPath.row].planet.title
            return CustomCollectionViewCellViewModel(titleString: datasource[indexPath.row].planet.title, descriptionString: nil)
        }
        else{
            // the rest of the cells have uitextviews
            return CustomCollectionViewCellViewModel(titleString: nil, descriptionString: datasource[indexPath.row].planet.description)
        }
    }
    
}
