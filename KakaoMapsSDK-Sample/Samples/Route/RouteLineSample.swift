//
//  RouteLineSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/30.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import UIKit
import KakaoMapsSDK

extension UIColor {
    public convenience init(hex: UInt32) {
        let r, g, b, a: CGFloat
        r = CGFloat((hex & 0xff000000) >> 24) / 255.0
        g = CGFloat((hex & 0x00ff0000) >> 16) / 255.0
        b = CGFloat((hex & 0x0000ff00) >> 8) / 255.0
        a = CGFloat((hex & 0x000000ff)) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

// Route를 사용하는 샘플.
// Route는 PolylineShape과 대부분 유사하나 여러 개의 개별적인 Polyline으로 구성되는 PolylineShape에 비해, 여러개의 segment로 구성된 하나의 선을 나타낸다. 길찾기경로선을 그리는 데에 주로 사용한다.
// 또한, Route는 스타일에 패턴을 가질 수 있고, 레벨에 따라 라인의 표현이 달라지는(라인의 축약, segment의 결합 등) LOD 기능을 가진다.
class RouteLineSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        createRouteStyleSet()
        createRouteline()
    }
    
    // RouteStyleSet을 생성한다.
    // 전체 구성은 PolylineStyleSet과 같다.
    // RouteSegment마다 RouteStyleSet에 있는 다른 RouteStyle을 적용할 수 있다.
    func createRouteStyleSet() {
        let mapView = mapController?.getView("mapview") as? KakaoMap
        let manager = mapView?.getRouteManager()
        let _ = manager?.addRouteLayer(layerID: "RouteLayer", zOrder: 0)
        let patternImages = [UIImage(named: "route_pattern_arrow.png"), UIImage(named: "route_pattern_walk.png"), UIImage(named: "route_pattern_long_dot.png")]
        
        // pattern
        let styleSet = RouteStyleSet(styleID: "routeStyleSet1")
        styleSet.addPattern(RoutePattern(pattern: patternImages[0]!, distance: 60, symbol: nil, pinStart: false, pinEnd: false))
        styleSet.addPattern(RoutePattern(pattern: patternImages[1]!, distance: 6, symbol: nil, pinStart: true, pinEnd: true))
        styleSet.addPattern(RoutePattern(pattern: patternImages[2]!, distance: 6, symbol: UIImage(named: "route_pattern_long_airplane.png")!, pinStart: true, pinEnd: true))
        
        let colors = [ UIColor(hex: 0x7796ffff),
                       UIColor(hex: 0x343434ff),
                       UIColor(hex: 0x3396ff00),
                       UIColor(hex: 0xee63ae00) ]

        let strokeColors = [ UIColor(hex: 0xffffffff),
                             UIColor(hex: 0xffffffff),
                             UIColor(hex: 0xffffff00),
                             UIColor(hex: 0xffffff00) ]
            
        let patternIndex = [-1, 0, 1, 2]
        
        for index in 0 ..< colors.count {
            let routeStyle = RouteStyle(styles: [
                PerLevelRouteStyle(width: 18, color: colors[index], strokeWidth: 4, strokeColor: strokeColors[index], level: 0, patternIndex: patternIndex[index])
            ])
 
            styleSet.addStyle(routeStyle)
        }

        manager?.addRouteStyleSet(styleSet)
    }
    
    func createRouteline() {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getRouteManager()
        let layer = manager.addRouteLayer(layerID: "RouteLayer", zOrder: 0)
        
        let segmentPoints = routeSegmentPoints()
        var segments: [RouteSegment] = [RouteSegment]()
        var styleIndex: UInt = 0
        for points in segmentPoints {
            // 경로 포인트로 RouteSegment 생성. 사용할 스타일 인덱스도 지정한다.
            let seg = RouteSegment(points: points, styleIndex: styleIndex)
            segments.append(seg)
            styleIndex = (styleIndex + 1) % 4
        }
        
        let options = RouteOptions(routeID: "routes", styleID: "routeStyleSet1", zOrder: 0)
        options.segments = segments
        let route = layer?.addRoute(option: options)
        route?.show()
        
        let pnt = segments[0].points[0]
        mapView.moveCamera(CameraUpdate.make(target: pnt, zoomLevel: 15, mapView: mapView))
    }
    
    func routeSegmentPoints() -> [[MapPoint]] {
        var segments = [[MapPoint]]()
        var coordinate: Bool = false
        
        if let filePath = Bundle.main.path(forResource: "routeSample_car", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filePath)
                let lines = contents.components(separatedBy: .newlines)
                
                var index = 0
                while index < lines.count - 1 {
                    
                    let line = lines[index]
                    
                    if coordinate && line == "end" {
                        break;
                    }
                    
                    if coordinate && line.count > 3 {
                        let coords = line.components(separatedBy: "|")
                        var points = [MapPoint]()
                        for coord in coords {
                            let pnt = coord.components(separatedBy: ",")
                            let converted = MapCoordConverter.fromWCongToWGS84(wcong: CartesianCoordinate(x: Double(pnt[0])!,
                                                                                                          y: Double(pnt[1])!))
                            points.append(MapPoint(longitude: converted.longitude,
                                                   latitude: converted.latitude))
                        }
                        segments.append(points)
                    }
                    
                    if line == "route" {
                        coordinate = true
                        index += 1
                    }
                    index += 1
                }
            } catch {
            }
        }
        return segments
    }
    
}
