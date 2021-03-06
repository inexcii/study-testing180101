/*
 * Copyright (c) 2014 Razeware LLC
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *  PlaceManagerTests.swift
 *  Places
 *
 *  Created by Soheil Azarpour on 7/4/14.
 */

import XCTest

class PlaceManagerTests: XCTestCase {
  
  let placeManager = PlaceManager.sharedManager()
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func test_placeManager_initialization() {
    var optionalManager: PlaceManager? = PlaceManager.sharedManager()
    XCTAssertTrue(optionalManager != nil, "PlaceManager failed to return shared instance.")
  }
  
  func test_localResourceFileURL_getter() {
    var localResourceURL: URL? = placeManager.localResourceFileURL
    XCTAssertNotNil(localResourceURL, "PlaceManager failed to return default local resource URL.")
  }
  
}
