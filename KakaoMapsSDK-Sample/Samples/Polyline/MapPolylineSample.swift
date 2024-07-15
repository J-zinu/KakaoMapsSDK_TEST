//
//  MapPolylineSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2020/11/05.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import UIKit
import KakaoMapsSDK

class MapPolylineSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        createPolylineStyleSet()
        createMapPolylineShape()
    }
    
    func testPolylineSegments() -> ([MapPolyline], AreaRect){
        var rect: AreaRect?
        var lines = [MapPolyline]()
        if let filePath = Bundle.main.path(forResource: "road_30", ofType: "json") {
            do {
                let data = try String.init(contentsOfFile: filePath).data(using: .utf8)
                if let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]] {
                    for jsonData in json {
                        if let mapPoints = jsonData["mapPoints"] as? [[String: Any]] {
                            
                            var coordinates = [MapPoint]()
                            for mapPoint in mapPoints {
                                if let points = mapPoint["points"] as? [String: Any] {
                                    let lats = points["lats"] as! [Double]
                                    let lngs = points["lngs"] as! [Double]
                                  
                                    var i = 0
                                    for _ in lats {
                                        coordinates.append(MapPoint(longitude: lngs[i], latitude: lats[i]))
                                        i = i+1
                                    }
                                    
                                }
                            }
                            
                            if rect == nil {
                                rect = AreaRect(points: coordinates)
                            }
                            else {
                                rect = AreaRect.union(rect!, AreaRect(points: coordinates))
                            }

                            lines.append(MapPolyline(line: coordinates, styleIndex: 0))
                        }

                    }
                }

            } catch {
                
            }
        }
        
        return (lines, rect!)
    }
    
    // StyleSet을 생성한다.
    // PolylineStyleSet은 한 개 이상의 PolylineStyle로 구성되고, PolylineStyle은 한 개 이상의 레벨별 스타일인 PerLevelPolylineStyle로 구성된다.
    // PerLevelPolylineStyle은 지정된 Polyline이 해당 레벨에서 어떻게 그려질지를 결정한다. 스타일이 지정되지 않았거나, 해당 레벨이 스타일이 지정되지 않은 구간이라면 Polyline은 그려지지 않는다.
    func createPolylineStyleSet() {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        let _ = manager.addShapeLayer(layerID: "PolylineLayer", zOrder: 10001)
        
        // 첫번째 스타일
        // 0 ~ 13레벨 : 빨간색의 외곽선을 가지는 파란색 선
        // 14 ~ 16레벨 : 초록색의 외곽선을 가지는 빨간색 선
        // 17 ~ 21레벨 : 빨간색의 외곽선을 가지는 녹샋선
        let polylineStyle = PolylineStyle(styles: [
            PerLevelPolylineStyle(bodyColor: UIColor.blue, bodyWidth: 18, strokeColor: UIColor.red, strokeWidth: 1, level: 0),
            PerLevelPolylineStyle(bodyColor: UIColor.red, bodyWidth: 18, strokeColor: UIColor.green, strokeWidth: 2, level: 14),
            PerLevelPolylineStyle(bodyColor: UIColor.green, bodyWidth: 18, strokeColor: UIColor.red, strokeWidth: 3, level: 17)
        ])
        
        // 두가지 스타일을 갖는 Set을 만든다. PolylineShape가 해당 StyleSet을 사용하면,
        // 각 폴리라인마다 스타일을 다르게 지정할 수 있다.
        manager.addPolylineStyleSet(PolylineStyleSet(styleSetID: "polylineStyleSet", styles: [polylineStyle]))
    }
    
    // MapPolylineShape를 생성한다.
    // MapPolyline은 별도의 base position없이 일련의 지도 좌표계(MapPoint)로 구성할 수 있다.
    func createMapPolylineShape() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        let layer = manager.getShapeLayer(layerID: "PolylineLayer")
        
        // line Point를 잇는 MapPolyline을 생성한다.
        // MapPolylineShape는 여러개의 MapPolyline으로 구성할 수 있다.
        let result = testPolylineSegments()
        let polylineSegments = result.0
        let rect = result.1
        
        // 여러개의 MapPolyline으로 구성된 MapPolylineShape를 생성한다.
        // MapPolylineShape는 id = "polylineStyleSet"인 StyleSet을 사용한다.
        // 여러개의 MapPolyline은 styleIndex = 0이며, 각 MapPolyline 단위마다 스타일을 다르게 지정할 수 있다.
        let options = MapPolylineShapeOptions(shapeID: "mapPolylines", styleID: "polylineStyleSet", zOrder: 1)
        options.polylines = polylineSegments
        
        // MapPolylineShape를 추가한다. 추가가 완료되었을 때의 콜백을 정의하면, 작업이 완료되었을 때 콜백을 받을 수 있다.
        let polyline = layer?.addMapPolylineShape(options)
        polyline?.show()

        let cameraUpdate = CameraUpdate.make(area: rect)
        mapView.moveCamera(cameraUpdate)
    
    }
}
