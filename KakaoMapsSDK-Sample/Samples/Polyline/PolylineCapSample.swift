//
//  PolylineCapSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/04/02.
//  Copyright © 2021 kakao. All rights reserved.
//

import Foundation
import UIKit
import KakaoMapsSDK

// Polyline에 Cap을 붙이는 예제.
// Polyline의 시작 혹은 끝부분에 다양한 스타일의 cap을 붙일 수 있다.
class PolylineCapSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        
        createPolylineStyleSet()
        createPolylineShape()
    }
    
    // Polyline의 Cap Style은 총 5가지 존재한다.
    // PolylineStyleSet단위로 CapStyle을 적용할 수 있다.
    // 예를 들어, PolylineStyleSet에 2개 이상의 PolylineStyle을 추가하고, round cap을 적용하게 되면 PolylineStyleSet에 속한 모든 PolylineStyle에 round cap이 일괄적으로 적용된다.
    func createPolylineStyleSet() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager: ShapeManager = mapView.getShapeManager()
        
        // PolylineStyle 생성.
        let style = PolylineStyle(styles: [
                                    PerLevelPolylineStyle(bodyColor: UIColor(hex: 0xf0f0f0ff), bodyWidth: 16, strokeColor: UIColor(hex: 0x444444ff), strokeWidth: 5, level: 0)
        ])
        
        // PolylineShape의 Cap은 PolylineStyleSet에서 지정한다.
        // 즉, 특정 StyleSet을 사용한 PolylineShape는 일괄적으로 cap이 적용된다.
        // 각각 다른 cap을 가진 5개의 StyleSet을 생성한다.
        for index in 0 ... 4 {
            let styleSet = PolylineStyleSet(styleSetID: "polylineStyle" + String(index), styles: [style], capType: PolylineCapType(rawValue: index)!)
            manager.addPolylineStyleSet(styleSet)
        }
    }
    
    // 생성한 스타일을 적용하여 PolylineShape를 생성한다.
    func createPolylineShape() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager: ShapeManager = mapView.getShapeManager()
        
        // PolylineShape추가를 위해 ShapeLayer 생성
        let layer = manager.addShapeLayer(layerID: "shapeLayer", zOrder: 10001)
        
        // 5가지 종류의 cap을 가진 StyleSet을 사용한 5개의 PolylineShape를 생성한다.
        let offset = 0.001347
        var pos = [MapPoint]()
        for index in 0 ... 4 {
            let option = PolylineShapeOptions(shapeID: "polyline" + String(index), styleID: "polylineStyle" + String(index), zOrder: 0)
            option.basePosition = MapPoint(longitude: 127.044395 + offset * Double(index),
                                           latitude: 37.505754) // 각 Polyline을 다른곳에 표시하기 위해 basePosition에 offset을 적용한다.
            
            // basePosition을 모델 좌표 중심점으로하는 총 3개의 points를 가진 Polyline을 생성한다.
            let polyline = Polyline(line: [
                CGPoint(x: -0.000898, y: 0.0),
                CGPoint(x: -0.0, y: 0.0),
                CGPoint(x: -0.0, y: 0.000898)
            ], styleIndex: 0)
            option.polylines = [polyline]
            
            // PolylineShape 생성. 각 5개의 PolylineShape가 각자 다른 type의 cap style을 가진다.
            let polylineShape = layer?.addPolylineShape(option)
            polylineShape?.show()
            
            // 화면에 5개 PolylineShape 표시를 위해 basePosition을 저장해둠
            pos.append(option.basePosition)
        }
        
        mapView.moveCamera(CameraUpdate.make(area: AreaRect(points: pos)))
    }
    
    let positions: [CGPoint] = [
        CGPoint(x: -100.0, y: 0.0),
        CGPoint(x: -0.0, y: 0.0),
        CGPoint(x: -0.0, y: 100.0)
    ]
}
