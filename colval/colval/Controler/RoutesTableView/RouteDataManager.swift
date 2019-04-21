//
//  RouteDataManager.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//   Based on  https://medium.com/swift2go/slim-uiviewcontroller-through-uitableview-datasource-delegate-encapsulation-86e88a7cc2ce
//   Alfian Losari   @   https://medium.com/@alfianlosari
//

import Foundation



public class RouteDataManager {
    public var routes: [Routes]    =  CoreData.sharedInstance.getRoutes()
    
    public var itemsCount: Int {
        return routes.count
    }
    public func item(at index: Int) -> Routes {
        return routes[index]
    }
    
    public func add(item: Routes) {
        routes.append(item)
    }
    
    public func delete(at index: Int) {
        routes.remove(at: index)
    }
    
    public func edit(item: Routes, at index: Int) {
        routes[index] = item
    } 
}
