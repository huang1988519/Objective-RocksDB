//
//  RocksDBColumnFamilyMetadataTests.swift
//  ObjectiveRocks
//
//  Created by Iska on 17/01/15.
//  Copyright (c) 2015 BrainCookie. All rights reserved.
//

import XCTest

class RocksDBColumnFamilyMetadataTests : RocksDBTests {

	func testSwift_ColumnFamilies_Metadata() {
		let descriptor = RocksDBColumnFamilyDescriptor()
		descriptor.addDefaultColumnFamilyWithOptions(nil)
		descriptor.addColumnFamilyWithName("new_cf", andOptions: nil)

		rocks = RocksDB(path: self.path, columnFamilies: descriptor, andDatabaseOptions: { (options) -> Void in
			options.createIfMissing = true
			options.createMissingColumnFamilies = true
		})

		let defaultColumnFamily = rocks.columnFamilies()[0] as! RocksDBColumnFamily
		let newColumnFamily = rocks.columnFamilies()[1] as! RocksDBColumnFamily

		defaultColumnFamily.setData(Data("df_value1"), forKey: Data("df_key1"))
		defaultColumnFamily.setData(Data("df_value2"), forKey: Data("df_key2"))

		newColumnFamily.setData(Data("cf_value1"), forKey: Data("cf_key1"))
		newColumnFamily.setData(Data("cf_value2"), forKey: Data("cf_key2"))

		let defaultMetadata = defaultColumnFamily.columnFamilyMetaData()
		XCTAssertNotNil(defaultMetadata);

		let newColumnFamilyMetadata = newColumnFamily.columnFamilyMetaData()
		XCTAssertNotNil(newColumnFamilyMetadata);
	}
}
