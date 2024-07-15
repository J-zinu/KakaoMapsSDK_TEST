//
//  ChangeEnabledRouteStyleSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2020/07/20.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

// 카카오맵에서 사용하는 길찾기 결과와 유사한 형태를 만드는 예제.
// 선택한 버튼에 해당하는 경로를 highlight하고, 나머지 경로는 disabled 상태로 바꾼다.
// Route의 changeStyleAndData를 사용한다.
//
// enabled Style / disabled style 두가지 스타일을 만들어서 관리한다.
class ChangeEnabledRouteStyleSample: APISampleBaseViewController, GuiEventDelegate {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        
        createButtonArray()
        createRouteLayer()
        createEnabledStyleSet()
        createDisabledStyleSet()
        createRouteLines()
    }
    
    // 경로 선택 버튼Array SpriteGui 생성
    func createButtonArray() {
        let mapView = mapController?.getView("mapview") as? KakaoMap
        let spriteLayer = mapView?.getGuiManager().spriteGuiLayer
        
        let spriteGui = SpriteGui("buttonArrray")
        spriteGui.arrangement = .horizontal
        spriteGui.origin = GuiAlignment(vAlign: .bottom, hAlign: .left)
        
        for index in 0 ... 3 {
            let btn = GuiButton(String(index+1))
            btn.image = UIImage(named: "tile.png")
            
            spriteGui.addChild(btn)
        }
        
        spriteGui.delegate = self
        spriteLayer?.addSpriteGui(spriteGui)
    }
    
    // RouteLines을 표시할 Layer를 생성한다.
    func createRouteLayer() {
        let mapView = mapController?.getView("mapview") as? KakaoMap
        let manager = mapView?.getRouteManager()
        let _ = manager?.addRouteLayer(layerID: "RouteLinesLayer", zOrder: 0)
    }
    
    // Eanbled Style을 생성한다. => 제일 위에 그려지는 Route의 Style
    func createEnabledStyleSet() {
        let mapView = mapController?.getView("mapview") as? KakaoMap
        let manager = mapView?.getRouteManager()
    
        let patternImages = [UIImage(named: "route_pattern_arrow.png"), UIImage(named: "route_pattern_walk.png"), UIImage(named: "route_pattern_long_dot.png")]
        
        // pattern
        let styleSet = RouteStyleSet(styleID: "enabledRoute")
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
    
    // Disabled Style을 생성한다. 밑에 그려질 Route들의 style.
    func createDisabledStyleSet() {
        let mapView = mapController?.getView("mapview") as? KakaoMap
        let manager = mapView?.getRouteManager()
    
        // pattern
        let styleSet = RouteStyleSet(styleID: "disabledRoute")
        styleSet.addPattern(RoutePattern(pattern: UIImage(named: "route_pattern_arrow.png")!, distance: 60, symbol: nil, pinStart: false, pinEnd: false))
        
        let routeStyle = RouteStyle(styles: [
            PerLevelRouteStyle(width: 16, color: UIColor(hex: 0x8d8d8dff), strokeWidth: 2, strokeColor: UIColor(hex: 0xffffffff), level: 0, patternIndex: 0)
        ])
        
        styleSet.addStyle(routeStyle)
        
        manager?.addRouteStyleSet(styleSet)
    }
    
    // 4개의 Route를 생성한다.
    func createRouteLines() {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getRouteManager()
        let layer = manager.getRouteLayer(layerID: "RouteLinesLayer")
        
        for index in 0 ... 3 {
            var styleID: String
            var zOrder: Int = 0
            
            if index == _enabledIndex {
                styleID = "enabledRoute"
                zOrder = _enabledZOrder
            }
            else {
                styleID = "disabledRoute"
                zOrder = index
            }
            
            // 해당 예제에서는 route를 구성하는 points를 임의로 offset을 주어 4개의 다른 경로를 구성한다.
            let segmentPoints = routeSegmentPoints(offset: 0.004491 * Double(index))
            
            var styleIndex: UInt = 0
            var segments = [RouteSegment]()
            for points in segmentPoints {
                if index != _enabledIndex {
                    styleIndex = 0
                }
                
                let segment = RouteSegment(points: points, styleIndex: styleIndex)
                segments.append(segment)
                
                styleIndex = (styleIndex + 1)%4
            }
            
            // route 추가
            let option = RouteOptions(routeID: "route"+String(index+1), styleID: styleID, zOrder: zOrder)
            option.segments = segments
            let route = layer?.addRoute(option: option)
            route?.show()
        }
    }
    
    // 해당 샘플에서는 같은 라인에 offset만 주어서 재활용해서 4개의 route segment를 구성하는 point data를 생성한다.
    // 실제 사용시에는 각각 다른 경로 탐색 결과를 segment로 사용한다.
    func routeSegmentPoints(offset: Double) -> [[MapPoint]] {
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
                            points.append(MapPoint(longitude: converted.longitude + offset,
                                                   latitude: converted.latitude + offset))
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
    
    func guiDidTapped(_ gui: GuiBase, componentName: String) {
        guard _enabledIndex != Int(componentName)! - 1 else {
            return
        }
        
        let mapView = mapController?.getView("mapview") as? KakaoMap
        let manager = mapView?.getRouteManager()
        let layer = manager?.getRouteLayer(layerID: "RouteLinesLayer")
        
        // disabled -> enabled로 먼저 바뀌는게 자연스럽다.
        let disabled = layer?.getRoute(routeID: "route"+componentName)
        
        var segments = [RouteSegment]()
        var styleIndex: UInt = 0
        
        // style 과 data를 업데이트 하기 위해 route segment 재 생성
        var segmentPoints = routeSegmentPoints(offset: Double(0.004491 * (Double(componentName)!-1)))
        for points in segmentPoints {
            let segment = RouteSegment(points: points, styleIndex: styleIndex)
            styleIndex = (styleIndex + 1)%4
            
            segments.append(segment)
        }
        
        // 스타일과 데이터를 바꾸고, 제일 위에 표시되게 하기 위해 zOrder를 변경한다.
        disabled?.changeStyleAndData(styleID: "enabledRoute", segments: segments)
        disabled?.zOrder = _enabledZOrder
        
        segments.removeAll()
        
        // enabled로 표시되고 있던 route를 enabled로 바꾸기
        let enabled = layer?.getRoute(routeID: "route"+String(_enabledIndex+1))
        segmentPoints = routeSegmentPoints(offset: Double(0.004491 * Double(_enabledIndex)))
        for points in segmentPoints {
            let segment = RouteSegment(points: points, styleIndex: 0)
            segments.append(segment)
        }
        
        // 스타일과 데이터를 바꾸고, 다시 아래로 내리기 위해 zOrder를 변경한다.
        enabled?.changeStyleAndData(styleID: "disabledRoute", segments: segments)
        enabled?.zOrder = _enabledIndex

        _enabledIndex = Int(componentName)!-1
    }

    let _enabledZOrder: Int = 100
    var _enabledIndex: Int = 0
}
