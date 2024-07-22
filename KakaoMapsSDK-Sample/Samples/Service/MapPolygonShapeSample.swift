//
//  MapPolygonShapeSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/06/29.
//  Copyright © 2021 kakao. All rights reserved.
//

// 경기도 면형을 MapPolygonShape로 표시하는 예제.
// MapPolygonShape는 지도좌표계(3857)로 구성되어있는 포인트 집합으로 Polygon을 구성할 수 있다.
// 경기도 면형을 표현하는 points를 가져와서 MapPolygonShape로 표현한다.

import Foundation
import KakaoMapsSDK

class MapPolygonShapeSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        
        createShapeStyle()
        createMapPolygonShape()
    }
    
    // MapPolygonShape를 표시할 스타일을 생성한다.
    func createShapeStyle() {
        let style = PolygonStyle(styles: [
            PerLevelPolygonStyle(color: UIColor(hex: 0xB4B4B4E6), strokeWidth: 2, strokeColor: UIColor.red, level: 0),
            PerLevelPolygonStyle(color: UIColor(hex: 0xB4000080), strokeWidth: 2, strokeColor: UIColor.red, level: 15)
        ])
        let styleSet = PolygonStyleSet(styleSetID: "shapeStyle", styles: [style])
        
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        
        manager.addPolygonStyleSet(styleSet)
    }
    
    // MapPolygonShape를 생성한다.
    func createMapPolygonShape() {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        let manager = mapView?.getShapeManager()
        let options = MapPolygonShapeOptions(shapeID: "kyounggi-do", styleID: "shapeStyle", zOrder: 1)
        // ShapeLayer
        let layer = manager?.addShapeLayer(layerID: "shapes", zOrder: 10001)
        options.polygons = loadData()
        
        let polygon = layer?.addMapPolygonShape(options)
        polygon?.show()
    }
    
    
    // 경기도 면형 데이터를 불러와서 MapPolygon 형태로 생성한다.
    // 하나의 MapPolygonShape는 여러개의 MapPolygon으로 구성할 수 있으며, MapPolygon은 하나의 exteriorRing과 0개 이상의 hole로 이루어질 수 있다.
    func loadData() -> [MapPolygon] {
        var polygons = [MapPolygon]()
        
        if let path = Bundle.main.path(forResource: "kyounggi-lod", ofType: "tsv") {
            do {
                let contents = try String(contentsOfFile: path)
                let lines = contents.components(separatedBy: .newlines)
                
                var index = 0
                while index < lines.count-1 {
                    let ringCount = Int(lines[index])!
                    index = index + 1
                    
                    var simplePolygon = [MapPoint]()
                    var holes = [[MapPoint]]()
                    var hole: [MapPoint]
                    
                    for rc in 1...ringCount {
                        var points = [MapPoint]()
                        let indexCount = Int(lines[index])!
                        
                        index += 1
                        for _ in 1...indexCount {
                            let coord = lines[index].components(separatedBy: "\t")
                            
                            let geoCoord = MapCoordConverter.fromKakaoToWGS84(kakao: CartesianCoordinate(x: Double(coord[1])!, y: Double(coord[2])!))
                            let point = MapPoint(longitude: geoCoord.longitude, latitude: geoCoord.latitude)
                            points.append(point)
                            
                            index += 1
                        }
                        if rc == 1 {
                            
                            simplePolygon = points
                        }
                        else {
                            hole = points
                            holes.append(hole)
                        }
                    }
                    
                    polygons.append(MapPolygon(exteriorRing: simplePolygon, holes: holes, styleIndex: 0))
                    
                }
                
            } catch {
                
            }
        }
        
        return polygons
    }
}


