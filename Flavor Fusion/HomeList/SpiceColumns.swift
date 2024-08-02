//
//  SpiceColumns.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 3/30/24.
//

import Foundation

/// Splits the `spiceData` array into two arrays for displaying in two columns.
///
/// `firstColumnSpices` contains the first half of the `spiceData` array.
/// `secondColumnSpices` contains the second half of the `spiceData` array.
public var firstColumnSpices: [Spice] {
    Array(spiceData.prefix(spiceData.count / 2))
}

public var secondColumnSpices: [Spice] {
    Array(spiceData.suffix(spiceData.count / 2))
}
