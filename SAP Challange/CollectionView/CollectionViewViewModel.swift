//
//  CollectionViewViewModel.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 18.07.2022.
//

import UIKit

class CollectionViewViewModel {
    
    /// a struct used to layout the cells, Like size, or visual state of the item
    struct LayoutItemObject{
        var size: CGSize
    }
    
    /// The possible ways the user can perform a pinch gesture with two fingers.
    enum GestureType{
        case horizontal
        case vertical
        case diagonal
    }
    
    /// this is the datasource we use to populate the collectionview
    var datasource = [SAPModel]()
    
    /// this is the layout object based on which the cells are arranged
    var layoutObj = [LayoutItemObject]()
    
    /// The total ammount of cells the collectionview will display horrizontally
    let nrOfCellsInRow = 3
    
    /// the space between cells
    let cellPadding: CGFloat = 2
    
    /// the width of the collectionview. Is set at the initialization of the view model
    private var collectionviewWidth: CGFloat!
    
    /// the maximum width that a cell can have.
    private var maxCellWidth: CGFloat!
    
    /// the minimum cell width.  Setting it lower then 50 can make cells harder to pinch, when they are at minimum size
    private(set) var minCellWidth: CGFloat = 50
    
    /// the default cell size. The cells size is calculated so that enought cells(defined by "nrOfCellsInRow") fit horizontally on the collectionview
    private var defaultCellSize: CGSize!
    
    /// this is the size of the cell that the user is currently interacting(pinching) with
    var focusedCellSize: CGSize?
    
    /// this is the ammount of scale applied on the width of the cell, while the user interacts with it
    private var horScale: CGFloat = 1
    
    /// this is the ammount of scale applied on the height of the cell, while the user interacts with it
    private var vertSacle: CGFloat = 1
    
    /// we deffined three possible types of pinch. While the user interacts(pinch) with a cell he can only do a horizontal, vertical, diagonal pinch.  Which will scale the cell horizontally, vertically or both
    private var pinchType: GestureType!
    
    
    init(collectionViewWidth: CGFloat){
        updateCollectionviewWidth(collectionViewWidth)
    }
    
    /// create the layoutObject for the collectionview
    private func initializeLayoutObject(){
        layoutObj.removeAll()
        datasource.forEach({_ in layoutObj.append(LayoutItemObject(size: defaultCellSize))})
    }
    
    
    
    //MARK: - Layout
    func updateCollectionviewWidth(_ newWidth: CGFloat){
        collectionviewWidth = newWidth
        self.maxCellWidth = calculateMaxCellWidth()
        self.defaultCellSize = calculateDefaultCellSize()
        datasource = DataSourceFactory.getData()
        initializeLayoutObject()
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
    
    //MARK: - Resizing Cells
    /// this function will update the size for all cells in the data source.First it will set the size for the cell that the user interacted with, and then it will update the size for the rest of the cells so that they don't break the originalgrid layout
    ///
    ///  - Parameter indexPath: The indexpath of the cell that the user is interacting(pinch) with.
    ///  - Parameter size: The new size which cell at the `indexPath` will have
    func setSizeForCellAt(indexPath: IndexPath, size: CGSize){
        /// this is the position in row that the cell with which the user interacted is. For example in a row that has 3 cells the `focusedCellPosition` can be 0, 1 or 2
        let focusedCellPosition = getPositionInRowFor(indexPath: indexPath)
        
        // First we make sure that the new size is valid
        let originalSizeForFocusedCell = layoutObj[indexPath.row].size
        let sizeForFocusedCell = validateFocusedCellSize(size)
        
        
        // Next we update the height for all cells that are on the same row with the cell that the user interacts with. We only need to update the height on this row according to the requirements (and example given)
        for idx in getAllRowIndexpathsFor(indexPath: indexPath){
            layoutObj[idx.row].size.height = sizeForFocusedCell.height
        }
        
        /// we create an array that holds the width for every cell in a row
        var cellsWidthInARow = [CGFloat]()
        for idx in getAllRowIndexpathsFor(indexPath: IndexPath(row: 0, section: 0)){
            if idx.row != focusedCellPosition{
                cellsWidthInARow.append(layoutObj[idx.row].size.width)
            }
        }
        
        
        // Next we find out by how much the cells width will change
        /// this is the total space by which the user interacted cell is changed (increased or decreased)
        let totalSpace = originalSizeForFocusedCell.width - sizeForFocusedCell.width
        cellsWidthInARow = distributeTheRemainingSpaceBetweenAllCellsInRow(cellsWidthInARow, spaceToDistribute: totalSpace)
        
        // after we finish distributing the space we also insert the cell width that the user interacetd with at the correct position in the row
        cellsWidthInARow.insert(sizeForFocusedCell.width, at: focusedCellPosition)
        
        
//        print("total = \(collectionviewWidth!)")
//        print("minCell = \(minCellWidth)")
//        print("max = \(maxCellWidth!)")
//        print("focused cell = \(sizeForFocusedCell.width)")
//        print("\(cellsWidthInARow[0]) + \(cellsWidthInARow[1]) + \(cellsWidthInARow[2]) + \((CGFloat(nrOfCellsInRow) + 1) * cellPadding)) = \(cellsWidthInARow[0] + cellsWidthInARow[1] + cellsWidthInARow[2] + ((CGFloat(nrOfCellsInRow) + 1) * cellPadding))")
        
        // And finally we update every cell width in the datasource, using the sizes we defind in `rowWidthSizes`
        for index in 0 ... layoutObj.count - 1{
            let rowPosition = index % nrOfCellsInRow
            layoutObj[index].size.width = cellsWidthInARow[rowPosition]
        }
        
    }
    /// this function will try to equally distribute(add or subtract) the given space(`spaceToDistribute`) between the "cells" of a row(`cellsWidthInARow`). If a "cell" reaches it's min/max size that cell is skipped, and the space is distributed among the rest. If all the "cells" reach their min/max size, the remaining undistributed space is ignorred.
    ///  - Parameter cellsWidthInARow: This array represents the width of each cell in a row. `spaceToDistribute` will be equally distributed between the cells(array elements) as long as the cell size doesn't go pass the min/max threshold, in that case the remaining space will only be distributed between the cells which can accept more space
    ///  - Parameter spaceToDistribute: This is the ammount of space that needs to be distributed among the "cells"(elements  of the `cellsWidthInARow`).
    func distributeTheRemainingSpaceBetweenAllCellsInRow(_ cellsWidthInARow: [CGFloat], spaceToDistribute: CGFloat) -> [CGFloat]{
        /// this is the total space by which the user interacted cell is changed (increased or decreased)
        var totalSpace = spaceToDistribute
        var row = cellsWidthInARow
        
        /// this is the space by which each indivitual cell in a row needs to increase or decrease
        let spacePerCellChange = totalSpace /  CGFloat(cellsWidthInARow.count)
        
        // Next we need to actually change the width for every cell in a row, so that we don't break the grid layout... Meaning, we actually need to change the rest of the cells width in the row, by the ammount of that whe changed that the user increased/decreased the cell.
        // we start a while loop in which we add/subtract space to each item in `rowWidthSizes`.
        var idx = -1
        while totalSpace != 0 {
            idx = (idx + 1 == row.count) ? 0 : idx + 1
            
            let crtCellWidth = row[idx]
            // this is the maximum ammount of space that we need to add or subtract from this cell
            let changeAmmount = (abs(spacePerCellChange) > abs(totalSpace)) ? totalSpace : spacePerCellChange
            
            // we check if the cell is allowed to grow or shrink by this ammount
            let newWidth = crtCellWidth + changeAmmount
            
            if newWidth > maxCellWidth{
                // looks like the cell will be bigger then the allowed size... we increase the size to maximum allowed
                row[idx] = maxCellWidth
                // we remove from the total space the ammount of space we added to this cell
                totalSpace -= maxCellWidth - crtCellWidth
                
                // we make sure that we never end in a neverending loop
                if row.reduce(0, +) == maxCellWidth * CGFloat(cellsWidthInARow.count){
                    break
                }
                continue
            }
            else if newWidth < minCellWidth{
                // looks like the cell will be smaller then the allowed size... we decrease the size to maximum allowed
                row[idx] = minCellWidth
                // we remove from the total space the ammount of space we added to this cell
                totalSpace -= minCellWidth - crtCellWidth
                
                // we make sure that we never end in a neverending loop
                if row.reduce(0, +) == minCellWidth * CGFloat(cellsWidthInARow.count){
                    break
                }
                continue
            }
            else{
                
                totalSpace -= changeAmmount
                row[idx] = newWidth
            }
        }
        
        return row
    }
    /// makes sure that the size is a valid size (within the min/max threshold). if not it returns the allowed sized
    func validateFocusedCellSize(_ size: CGSize) -> CGSize{
        if size.width > maxCellWidth{
            return CGSize(width: maxCellWidth, height: size.height)
        }
        else if size.width < minCellWidth{
            return CGSize(width: minCellWidth, height: size.height)
        }
        
        return size
    }
    
    
    //MARK: - Helpers
    /// returns the row position of a cell at a specific index path. For example if the collectionview has 3 cells in a row, the idx 0,1 or 2 will return position 0,1 or 2 but idx 3 will return position 0 since it's the first cell on the second row
    func getPositionInRowFor(indexPath: IndexPath) -> Int{
        let result = indexPath.row % nrOfCellsInRow
        return result
    }
    
    /// returns an array holding all the indexpaths that are on the same row with the provided indexpath
    func getAllRowIndexpathsFor(indexPath: IndexPath) -> [IndexPath]{
        let position = getPositionInRowFor(indexPath: indexPath)
        let rowStart = indexPath.row - position
        var rowEnd = rowStart + nrOfCellsInRow - 1
        if rowEnd >= layoutObj.count {
            rowEnd = layoutObj.count - 1
        }
        
        var indexes = [IndexPath]()
        for i in rowStart ... rowEnd{
            indexes.append(IndexPath(row: i, section: 0))
        }
        return indexes
    }
    
    /// generates and returns CustomCellViewModels
    func getCellModel(indexPath: IndexPath) -> CustomCollectionViewCellViewModel{
        return CustomCollectionViewCellViewModel(model: datasource[indexPath.row])
    }
    
    //MARK: Pinch Gesture
    /// this function will calculate the new size for the cell which the user interacts with.
    func calculateSizeFor(pinchGesture: UIPinchGestureRecognizer) -> CGSize?{
        // we need at least 2 points to calculate the angle
        guard pinchGesture.numberOfTouches > 1 else {return nil}
        let locationOne = pinchGesture.location(ofTouch: 0, in: pinchGesture.view)
        let locationTwo = pinchGesture.location(ofTouch: 1, in: pinchGesture.view)
        pinchType = determinegestureTypeForTouchLocations(loc1: locationOne, loc2: locationTwo)

        if pinchGesture.state == .began{
            // at the beggining of the gesture we store the original size of the cell and we reset any scale that we previously set
            focusedCellSize = pinchGesture.view?.frame.size
            horScale = 1
            vertSacle = 1
        }
        else if pinchGesture.state == .changed{
            // during the change we apply the scale on width/height depending on the gesture type
            return calculateCellSizeForPinchGestureType(pinchType, scale: pinchGesture.scale)
        }
        
        return nil
    }
    
    /// returns the size of the cell. The size is changed on different axes based on the gesture. The gesture is devided in three types: horizontal(will only change the width), vertical(will only change the height), diagonal(will change both)
    func calculateCellSizeForPinchGestureType(_ gestureType: GestureType, scale: CGFloat) -> CGSize?{
        guard let size = focusedCellSize else {return nil}
        switch gestureType{
        case .horizontal:
            horScale = scale
            var width = size.width * horScale
            if width > maxCellWidth{
                width = maxCellWidth
            }
            return CGSize(width: width, height: size.height * vertSacle)
        case .vertical:
            vertSacle = scale
            var width = size.width * horScale
            if width > maxCellWidth{
                width = maxCellWidth
            }
            return CGSize(width: width, height: size.height * vertSacle)
        case .diagonal:
            horScale = scale
            vertSacle = scale
            var width = size.width * horScale
            if width > maxCellWidth{
                width = maxCellWidth
            }
            return CGSize(width: width, height: size.height * vertSacle)
        }
    }
    
    /// returns the type of the pinch gesture. If the two touch locations of the fingers are spread more horizontally or vertically it will return one of the two types, or it will return "diagonally" if it's the case
    func determinegestureTypeForTouchLocations(loc1: CGPoint, loc2: CGPoint) -> GestureType{
        let diffX = loc1.x - loc2.x
        let diffY = loc1.y - loc2.y
        
        /// the angle of the gesture
        let bearingAngle = diffY == 0 ? CGFloat.pi / 2.0 : abs(atan(diffX / diffY))
        
        if bearingAngle < CGFloat.pi / 6.0 {
            // vertical
            return .vertical
        }
        else if bearingAngle < CGFloat.pi / 3.0 {
            // diagonal
            return .diagonal
        }
        else if bearingAngle <= CGFloat.pi / 2.0 {
            // horizontal
            return .horizontal
        }
        
        return .diagonal
    }
    
    
    
}
