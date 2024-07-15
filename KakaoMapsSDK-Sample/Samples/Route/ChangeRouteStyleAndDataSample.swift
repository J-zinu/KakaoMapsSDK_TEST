//
//  ChangeRouteStyleAndDataSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2020/07/20.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

// changeDataAndStyle을 이용해서 Route의 style과 data를 변경하는 예제
// changeDataAndStyle 함수는 id가 변하지 않는 상태에서 line의 좌표나 스타일 index, 혹은 사용하는 스타일이 바뀌는 경우 사용한다.
// 해당 샘플은 교통정보를 길찾기 라인에 표시하는 예제이고, 1초마다 route를 구성하는 segment의 style index값을 변경한다.
class ChangeRouteStyleAndDataSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        
        createRouteLayer()
        createRouteStyleSet()
        createRouteLine()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        
        _timer?.invalidate()
    }

    // RouteLines을 표시할 Layer를 생성한다.
    func createRouteLayer() {
        let mapView = mapController?.getView("mapview") as? KakaoMap
        let manager = mapView?.getRouteManager()
        let _ = manager?.addRouteLayer(layerID: "RouteLineLayer", zOrder: 0)
    }
    
    // StyleSet을 생성한다.
    func createRouteStyleSet() {
        let mapView = mapController?.getView("mapview") as? KakaoMap
        let manager = mapView?.getRouteManager()
        
        // pattern
        let styleSet = RouteStyleSet(styleID: "routeStyle")
        styleSet.addPattern(RoutePattern(pattern: UIImage(named: "route_pattern_arrow.png")!, distance: 60, symbol: nil, pinStart: false, pinEnd: false))

        let colors = [ UIColor(hex: 0xff3829ff),
                       UIColor(hex: 0xffb629ff),
                       UIColor(hex: 0x39d729ff),
                       UIColor(hex: 0x949294ff),
                       UIColor(hex: 0xffe300ff)]

        let strokeColors = [ UIColor(hex: 0xffffffff),
                             UIColor(hex: 0xffffffff),
                             UIColor(hex: 0xffffffff),
                             UIColor(hex: 0xffffffff),
                             UIColor(hex: 0xffffffff)]
        
        for index in 0 ..< colors.count {
            let routeStyle = RouteStyle(styles: [
                PerLevelRouteStyle(width: 18, color: colors[index], strokeWidth: 4, strokeColor: strokeColors[index], level: 0, patternIndex: 0)
            ])
            
            styleSet.addStyle(routeStyle)
        }

        manager?.addRouteStyleSet(styleSet)
    }
    
    func createRouteLine() {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getRouteManager()
        let layer = manager.getRouteLayer(layerID: "RouteLineLayer")
        
        // routeSegments를 구성하는 points 생성
        let segmentPoints = routeSegmentPoints()
        
        var styleIndex: UInt = 0
        var segments = [RouteSegment]()
        for points in segmentPoints {
            let segment = RouteSegment(points: points, styleIndex: styleIndex)
            segments.append(segment)
            
            styleIndex = (styleIndex + 1)%4
        }
        
        _segmentsCount = segments.count
        
        // route 추가
        let options = RouteOptions(routeID: "route1", styleID: "routeStyle", zOrder: 0)
        options.segments = segments
        let route = layer?.addRoute(option: options)
        route?.show()
        
        // 1초에 한번씩 update하는 runloop추가
        _timer = Timer.init(timeInterval: 1, target: self, selector: #selector(onUpdateStyle), userInfo: nil, repeats: true)
         RunLoop.current.add(_timer!, forMode: RunLoop.Mode.common)
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
                            let converted = MapCoordConverter.fromWCongToWGS84(wcong: CartesianCoordinate(x: Double(pnt[0])!, y: Double(pnt[1])!))
                            points.append(MapPoint(longitude: converted.longitude, latitude: converted.latitude))
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
    
    // 1초에 한번씩 호출되면서 보여지고있는 route segments의 styleIndex를 업데이트한다.
    @objc func onUpdateStyle() {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getRouteManager()
        let layer = manager.getRouteLayer(layerID: "RouteLineLayer")
        let route = layer?.getRoute(routeID: "route1")
        
        // routeSegments를 구성하는 points 생성
        let segmentPoints = routeSegmentPoints()
        
        var segments = [RouteSegment]()
        for points in segmentPoints {
            
            // segment의 styleIndex를 0~4 사이로 랜덤하게 업데이트 한다.
            let segment = RouteSegment(points: points, styleIndex: UInt(arc4random_uniform(5)))
            segments.append(segment)
        }
        
        route?.changeStyleAndData(styleID: "routeStyle", segments: segments)
    }
    
    var _segmentsCount: Int = 0
    var _timer: Timer?
}
