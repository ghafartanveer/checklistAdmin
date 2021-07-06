//
//  GraphStatesListViewModel.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmad on 06/07/2021.
//

import Foundation

import Foundation
import SwiftyJSON

class GraphStatesListViewModel {
    var graphList:[GraphStatesViewModel]
    
    init() {
        self.graphList = [GraphStatesViewModel]()
    }
    
    convenience init(obj: JSON) {
        self.init()
        
        for (key, value) in obj[0] {
            
            let list = GraphStatesViewModel(info: value, dayName: key)
            self.graphList.append(list)
        }
        //        for (key, value) in obj[0] {
        //            let list = GraphStatesViewModel(info: value, dayName: key)
        //           // graphList.append(contentsOf: graphList)
        //
        //            switch key {
        //            case "Monday":
        //                self.graphList.insert(list, at: 0)
        //            case "Tuesday":
        //                self.graphList.insert(list, at: 1)
        //
        //            case "Wednesday":
        //                self.graphList.insert(list, at: 2)
        //
        //            case "Thursday":
        //                self.graphList.insert(list, at: 3)
        //
        //            case "Friday":
        //                self.graphList.insert(list, at: 4)
        //
        //            case "Saturday":
        //                self.graphList.insert(list, at: 5)
        //
        //            case "Sunday":
        //                self.graphList.insert(list, at: 6)
        //
        //            default:
        //                print("Not yet dfined")
        //            }
        //        }
    
    }
}
