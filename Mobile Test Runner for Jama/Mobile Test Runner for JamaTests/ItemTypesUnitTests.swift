//
//  ItemTypesUnitTests.swift
//  Mobile Test Runner for Jama
//
//  Created by Meghan McBee on 9/4/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import XCTest
@testable import Mobile_Test_Runner_for_Jama

class ItemTypesUnitTests: XCTestCase {
    
    var itemTypes: ItemTypes = ItemTypes()
    var itemTypeData: [[String: AnyObject]] = []
    var planitem: [String : AnyObject] = [:]
    var cycleitem: [String : AnyObject] = [:]
    var runitem: [String : AnyObject] = [:]
    var wrongitem: [String : AnyObject] = [:]
    var plankey = "TSTPL"
    var cyclekey = "TSTCY"
    var runkey = "TSTRN"
    var wrongkey = "WRONG"
    var planid = 35
    var cycleid = 36
    var runid = 37
    var wrongid = 99
    
    let username = "demo"
    let password = "password"
    let instance = "capstone-sandbox"
    
    override func setUp() {
        super.setUp()
        //build API response data
        planitem.updateValue(planid as AnyObject, forKey: "id")
        planitem.updateValue(plankey as AnyObject, forKey: "typeKey")
        cycleitem.updateValue(cycleid as AnyObject, forKey: "id")
        cycleitem.updateValue(cyclekey as AnyObject, forKey: "typeKey")
        runitem.updateValue(runid as AnyObject, forKey: "id")
        runitem.updateValue(runkey as AnyObject, forKey: "typeKey")
        wrongitem.updateValue(wrongid as AnyObject, forKey: "id")
        wrongitem.updateValue(wrongkey as AnyObject, forKey: "typeKey")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExtractItemsFromData() {
        itemTypeData.append(wrongitem)
        itemTypeData.append(planitem)
        itemTypeData.append(cycleitem)
        itemTypeData.append(runitem)
        
        itemTypes.extractItemTypes(fromData: itemTypeData)
        
        XCTAssertEqual(planid, itemTypes.planId)
        XCTAssertEqual(plankey, itemTypes.planKey)
        XCTAssertEqual(cycleid, itemTypes.cycleId)
        XCTAssertEqual(cyclekey, itemTypes.cycleKey)
        XCTAssertEqual(runid, itemTypes.runId)
        XCTAssertEqual(runkey, itemTypes.runKey)
        XCTAssertEqual(itemTypeData.count, itemTypes.totalItemTypesReturned)
    }
    
    func testFoundAllTypes() {
        itemTypeData.append(planitem)
        itemTypeData.append(cycleitem)
        itemTypeData.append(runitem)
        itemTypeData.append(wrongitem)
        
        itemTypes.extractItemTypes(fromData: itemTypeData)
        
        XCTAssertFalse(itemTypes.didNotFindAllTypes())
        XCTAssertNotEqual(itemTypeData.count, itemTypes.totalItemTypesReturned)
    }
    
    func testDidNotFindAllTypes() {
        itemTypeData.append(wrongitem)
        itemTypeData.append(planitem)
        itemTypeData.append(wrongitem)
        itemTypeData.append(cycleitem)
        itemTypeData.append(wrongitem)
        
        itemTypes.extractItemTypes(fromData: itemTypeData)
        
        XCTAssertTrue(itemTypes.didNotFindAllTypes())
        XCTAssertEqual(itemTypeData.count, itemTypes.totalItemTypesReturned)
    }
    
    func testGetItemIds() {
        itemTypes.getItemIds(instance: instance, username: username, password: password)
        
        XCTAssertEqual(self.username, itemTypes.username)
        XCTAssertEqual(self.password, itemTypes.password)
        XCTAssertEqual(itemTypes.endpointString, "https://capstone-sandbox.jamacloud.com/rest/latest/itemtypes")
    }
}
