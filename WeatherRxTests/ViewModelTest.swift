//
//  ViewModelTest.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-09-05.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxBlocking

@testable import WeatherRx

class ViewModelTests: XCTestCase {
    
    private func createViewModel(lat: Double, lon: Double) -> ViewModel {
        return ViewModel(lat: lat, lon: lon, apiType: MockInternetService.self, imageDataCacheType: ImageDataCaching.self)
    }
    
    func test_whenInitialized_storesInitParams() {
        let lat = 43.6532
        let lon = -79.3832
        let viewModel = createViewModel(lat: lat, lon: lon)
        
        XCTAssertNotNil(viewModel.lat)
        XCTAssertNotNil(viewModel.lon)
        XCTAssertNotNil(viewModel.apiType)
        XCTAssertNotNil(viewModel.imageDataCacheType)
    }
    
    func test_whenInit_callsBindToBackgroundImage_FetchImage() {
        let lat = 43.6532
        let lon = -79.3832
        let viewModel = createViewModel(lat: lat, lon: lon)
        
        let backgroundImage = viewModel.flickrImage.asObservable()
        
        DispatchQueue.main.async {
            MockInternetService.imageURLResult.onNext(Result<NSURL, Error>.Success(TestData.stubImageURL!))
            MockInternetService.imageDataResult.onNext(Result<Data, Error>.Success(TestData.stubFlickrImageData!))
        }
        
        let emitted = try! backgroundImage.take(2).toBlocking(timeout: 1).toArray()
        XCTAssertEqual(UIImagePNGRepresentation(emitted[0]!), UIImagePNGRepresentation(UIImage(named: "banff")!))
        XCTAssertEqual(UIImagePNGRepresentation(emitted[1]!), TestData.stubFlickrImageData)
        
    }
    
    
    
}
