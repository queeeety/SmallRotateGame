//
//  SmallRotateGameTests.swift
//  SmallRotateGameTests
//
//  Created by Тимофій Безверхий on 22.08.2024.
//

import Testing
@testable import SmallRotateGame
@Test func firstCheck(){
    // Given
    // When
    let map = generateMap()
    
    // Then
    #expect(factChecking(level_map_int: map.0, level_map_connections: map.1) == true)
}
