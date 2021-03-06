//
//  RocksDBPropertiesTests.swift
//  ObjectiveRocks
//
//  Created by Iska on 11/01/15.
//  Copyright (c) 2015 BrainCookie. All rights reserved.
//

import Foundation
import XCTest

class RocksDBPropertiesTests : RocksDBTests {

	func testSwift_Properties() {
		rocks = RocksDB(path: self.path, andDBOptions: { (options) -> Void in
			options.createIfMissing = true
			options.maxWriteBufferNumber = 10;
			options.minWriteBufferNumberToMerge = 10;
		})

		rocks.setData(Data("value 1"), forKey: Data("key 1"))
		rocks.setData(Data("value 2"), forKey: Data("key 2"))
		rocks.setData(Data("value 3"), forKey: Data("key 3"))

		XCTAssertGreaterThan(rocks.valueForIntProperty(String(RocksDBIntPropertyNumEntriesInMutableMemtable)), 0 as UInt64);
		XCTAssertGreaterThan(rocks.valueForIntProperty(String(RocksDBIntPropertyCurSizeActiveMemTable)), 0 as UInt64);
	}

	func testSwift_Properties_ColumnFamily() {

		let descriptor = RocksDBColumnFamilyDescriptor()
		descriptor.addDefaultColumnFamilyWithOptions(nil)
		descriptor.addColumnFamilyWithName("new_cf", andOptions: nil)

		rocks = RocksDB(path: path, columnFamilies: descriptor, andDatabaseOptions: { (options) -> Void in
			options.createIfMissing = true
			options.createMissingColumnFamilies = true
		})

		XCTAssertGreaterThanOrEqual(rocks.columnFamilies()[0].valueForIntProperty(String(RocksDBIntPropertyEstimatedNumKeys)), 0 as UInt64);
		XCTAssertNotNil(rocks.columnFamilies()[0].valueForProperty(String(RocksDBPropertyStats)));
		XCTAssertNotNil(rocks.columnFamilies()[0].valueForProperty(String(RocksDBPropertySsTables)));

		XCTAssertGreaterThanOrEqual(rocks.columnFamilies()[1].valueForIntProperty(String(RocksDBIntPropertyEstimatedNumKeys)), 0 as UInt64);
		XCTAssertNotNil(rocks.columnFamilies()[1].valueForProperty(String(RocksDBPropertyStats)));
		XCTAssertNotNil(rocks.columnFamilies()[1].valueForProperty(String(RocksDBPropertySsTables)));
	}
}
