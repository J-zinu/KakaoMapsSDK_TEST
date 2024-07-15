//
//  TappedEventHandler.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2020/09/17.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

class TappedEventHandler: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.02768, latitude: 37.498254)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        
        // 카메라 이동 멈춤 핸들러를 추가한다.
        let mapView = mapController?.getView("mapview") as! KakaoMap
        _mapTapEventHandler = mapView.addMapTappedEventHandler(target: self, handler: TappedEventHandler.mapDidTapped)
        _terrainTapEventHandler = mapView.addTerrainTappedEventHandler(target: self, handler: TappedEventHandler.terrainTapped)
        _terrainLongTapEventHandler = mapView.addTerrainLongPressedEventHandler(target: self, handler: TappedEventHandler.terrainLongTapped)
    }
    
    func mapDidTapped(_ param: ViewInteractionEventParam) {
        let mapView = param.view as! KakaoMap
        let position = mapView.getPosition(param.point)
        
        print("Tapped: \(position.wgsCoord.latitude), \(position.wgsCoord.latitude)")
        
        _mapTapEventHandler?.dispose()
    }
    
    func terrainTapped(_ param: TerrainInteractionEventParam) {
        let position = param.position.wgsCoord
        print("Terrain Tapped: \(position.longitude), \(position.latitude)")
        
        _terrainTapEventHandler?.dispose()
    }
    
    func terrainLongTapped(_ param: TerrainInteractionEventParam) {
        let position = param.position.wgsCoord
        print("Terrain Long Tapped: \(position.longitude), \(position.latitude)")
        
        _terrainLongTapEventHandler?.dispose()
    }
    
    var _mapTapEventHandler: DisposableEventHandler?
    var _terrainTapEventHandler: DisposableEventHandler?
    var _terrainLongTapEventHandler: DisposableEventHandler?
}
