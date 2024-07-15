//
//  JejuBusSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2020/08/12.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

// tuple (option, positions, busType)
typealias BusData = (PoiOptions, [MapPoint], Float, String)

struct Bus: Decodable {
    enum CodingKeys: String, CodingKey {
        case busline = "busline"
        case vehicles = "vehicles"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        busline = try container.decode(BusLine.self, forKey: .busline)
        vehicles = try container.decode([Vehicle].self, forKey: .vehicles)
    }
    
    let busline: BusLine
    let vehicles: [Vehicle]
}

struct Vehicle: Decodable{
    enum CodingKeys: String, CodingKey {
        case vehicleNumber = "vehicle_number"
        case locations = "locations"
    }
    
    let vehicleNumber: String
    var coords: [MapPoint]
    var baseRadian: Float
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        vehicleNumber = try container.decode(String.self, forKey: .vehicleNumber)
        let locations = try container.decode([String].self, forKey: .locations)
        
        coords = [MapPoint]()
        baseRadian = 0.0
        for location in locations {
            let coord = location.components(separatedBy: ":")
            let pnt = coord[1].components(separatedBy: ",")
            let converted = MapCoordConverter.fromWCongToWGS84(wcong: CartesianCoordinate(x: Double(pnt[0])!, y: Double(pnt[1])!))
            
            coords.append(MapPoint(longitude: converted.longitude, latitude: converted.latitude))
            if coord.count > 2 {
                if let value = Float.init(coord[2]) {
                    baseRadian = value * Float(Double.pi) / 180.0
                }
            }
        }
    }
}

struct BusLine: Decodable {

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case subtype = "subtype"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        subtype = try container.decode(String.self, forKey: .subtype)
    }

    let subtype: String
    let name: String
}

// JejuBus를 생성하는 예제
// 3초에 한번씩 데이터를 로드해서 위치를 업데이트한다.
// JejuBus는 Poi를 이용하여 생성하고, 클릭된 JejuBus를 하이라이트 하기 위해 PolygonShape와 ShapeAnimator를 이용하낟.
class JejuBusSample: APISampleBaseViewController, KakaoMapEventDelegate {

    override func willMove(toParent parent: UIViewController?) {
        
        _timer?.invalidate()
    }
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.02768, latitude: 37.498254)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        _busTypes["blue"] = UIColor(hex: 0x003399ff)
        _busTypes["green"] = UIColor(hex: 0x22741cff)
        _busTypes["red"] = UIColor(hex: 0xeb3232ff)
        _busTypes["yellow"] = UIColor(hex: 0xffbb00ff)
        _busTypes["airport"] = UIColor(hex: 0x747474ff)
        
        createLabelLayer()
        
        for type in _busTypes {
            createJejuBusStyle(type: type.key, color: type.value)
            createCirclePolygon(type: type.key, color: type.value)
        }
        
        createWaveEffectAnimator()
        createJejuBus()
    }
    
    // 제주버스를 넣을 레이어를 생성한다.
    func createLabelLayer() {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        mapView.eventDelegate = self
        
        let manager = mapView.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "example_jeju_bus", competitionType: .none, competitionUnit: .poi, orderType: .rank, zOrder: 10011)
        let _ = manager.addLabelLayer(option: layerOption)
    }
    
    // 제주버스 스타일을 생성한다. 총 5개의 스타일이 존재하고, 각 스타일은 5개의 레벨별 스타일을 갖는다.
    // 즉, 5개의 제주버스 스타일이 각 레벨구간마다 다르게 표시된다.
    func createJejuBusStyle(type: String, color: UIColor) {
        let levels = [10, 7, 3, 2, 1];
        let fileName = "mapbusico_"
        
        var levelStyles = [PerLevelPoiStyle]()
        for level in levels {
            let icon = PoiIconStyle(symbol: UIImage(named: fileName + type + "_" + String(level) + "_lv.png"))
            let textLine = PoiTextLineStyle(textStyle: TextStyle(fontSize: 28, fontColor: color, strokeThickness: 3, strokeColor: UIColor(hex: 0x00000000)))
            let text = PoiTextStyle(textLineStyles: [textLine])
            text.textLayouts = [.center]
            if level < 3 {
                levelStyles.append(PerLevelPoiStyle(iconStyle: icon, textStyle: text, level: level == 10 ? 0:(19-level)))
            }
            else {
                levelStyles.append(PerLevelPoiStyle(iconStyle: icon, level: level == 10 ? 0:(19-level)))
            }
        }
        
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        let busStyle = PoiStyle(styleID: type, styles: levelStyles)
        manager.addPoiStyle(busStyle)
    }
    
    // 클릭시 하이라이트를 위한 PolygonShape를 생성한다.
    // Circle형태를 갖는 PolygonShape.
    func createCirclePolygon(type: String, color: UIColor) {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        
        // shapeLayer 생성. 물결 폴리곤을 route보다 위에 그려지게 설정.
        let shapeLayer = manager.addShapeLayer(layerID: "polygon_circle_jejubus", zOrder: 10001, passType: .route)
        
        let polygonStyle = PolygonStyle(styles: [
            PerLevelPolygonStyle(color: color, level: 0)
        ])
        let styleSet = PolygonStyleSet(styleSetID: "jejuBus_" + type)
        styleSet.addStyle(polygonStyle)
        
        manager.addPolygonStyleSet(styleSet)
        
        let shapeOption = PolygonShapeOptions(shapeID: type, styleID: "jejuBus_" + type, zOrder: 0)
        let circle = Polygon(exteriorRing: Primitives.getCirclePoints(radius: 1, numPoints: 90, cw: true), hole: nil, styleIndex: 0)
        shapeOption.polygons.append(circle)
        shapeOption.basePosition = MapPoint(longitude: 127.044395, latitude: 37.505754)
        let _ = shapeLayer?.addPolygonShape(shapeOption)
    }
    
    // 생성한 Circle PolygonShape에 애니메이션 효과를 주기 위한 Animator를 생성한다.
    // Animator는 레벨별로 다른 크기를 갖는다.
    func createWaveEffectAnimator() {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        
        let effect = WaveAnimationEffect(datas: [
            WaveAnimationData(startAlpha: 0.7, endAlpha: 0.0, startRadius: 10, endRadius: 30, level: 0),
            WaveAnimationData(startAlpha: 0.7, endAlpha: 0.0, startRadius: 10, endRadius: 62.5, level: 12),
            WaveAnimationData(startAlpha: 0.7, endAlpha: 0.0, startRadius: 10, endRadius: 87.5, level: 16),
            WaveAnimationData(startAlpha: 0.7, endAlpha: 0.0, startRadius: 10, endRadius: 125.5, level: 17),
            WaveAnimationData(startAlpha: 0.7, endAlpha: 0.0, startRadius: 10, endRadius: 300, level: 18)
        ])
        effect.hideAtStop = true
        effect.interpolation = AnimationInterpolation(duration: 500, method: .cubicOut)
        effect.playCount = 1000000
        
        let _ = manager.addShapeAnimator(animatorID: "circleWave_jejubus", effect: effect)
    }
    
    // 스타일 & 레이어와 PolygonShape를 생성한 후, 3초에 한번씩 데이터를 로드하는 RunLoop를 생성한다.
    func createJejuBus() {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        mapView.moveCamera(CameraUpdate.make(cameraPosition: CameraPosition(target: MapPoint(longitude: 126.496467, latitude: 33.488874), height: 1000.0, rotation: 0.0, tilt: 0.0)))
        
        _timer = Timer.init(timeInterval: 3, target: self, selector: #selector(updateJejuBus), userInfo: nil, repeats: true)
        RunLoop.current.add(_timer!, forMode: RunLoop.Mode.common)
    }

    // 3초에 한번씩 실행. JejuBus를 지도에 추가하여 표시하고, 경로에 따라 이동시킨다.
    @objc func updateJejuBus() {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "example_jeju_bus")
        
        // 데이터 로드
        let datas = loadData(index: _jsonIndex)
        
        // Bus 정보와 path 정보를 로드한 데이터로부터 얻어오고, bus poi를 추가하고 path에 맞게 이동시킨다.
        for data in datas {
            
            // 예제에서 다루는 busType외의 데이터는 생성하지 않음
            if _busTypes[data.3] != nil {
                if let bus = _buses[data.0.itemID!] {
                    bus.show()
                    bus.moveAndRotateOnPath(data.1, baseRadian: data.2, duration: 3000, cornerRadius: 2.0, jumpThreshold: 200.0)
                    
                    // polygon 색깔 구분을 위해 type넣어놓음
                    bus.userObject = data.3 as AnyObject
                }
                else {
                    let poi = layer?.addPoi(option: data.0, at: data.1[0])
                    poi?.show()
                    poi?.moveAndRotateOnPath(data.1, baseRadian: data.2, duration: 3000, cornerRadius: 2.0, jumpThreshold: 200.0)
                    
                    // polygon 색깔 구분을 위해 type넣어놓음
                    poi?.userObject = data.3 as AnyObject
                    _buses[(poi?.itemID)!] = poi
                }
            }
        }

        _jsonIndex = (_jsonIndex == 25) ? 1:(_jsonIndex+1)
    }
    
    func loadData(index: Int) -> [BusData] {
        var datas = [BusData]()
        
        if let path = Bundle.main.path(forResource: String(index), ofType: "txt") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let busDatas = try JSONDecoder().decode([Bus].self, from: data)
                var rank: Int = 0
                
                for busData in busDatas {
                    let vehicles = busData.vehicles
                    let name = busData.busline.name
                    let type = busData.busline.subtype.lowercased()
                    
                    // JejuBus Poi생성을 위한 옵션을 지정한다.
                    for vehicle in vehicles {
                        let option = PoiOptions(styleID: type, poiID: vehicle.vehicleNumber)
                        option.clickable = true // 탭 이벤트 발생을 위해 clickable을 true로 설정
                        option.rank = Int(rank)
                        option.transformType = .absoluteRotationDecal   // 지도 틸팅시 버스가 바닥에 붙어있는 효과를 위해 decal로 지정
                        option.addText(PoiText(text: name, styleIndex: 0))
                        rank += 1
                        
                        datas.append((option, vehicle.coords, vehicle.baseRadian, type))
                    }
                }
            
            } catch {
                
            }
        }

        return datas
    }
    
    // JejuBus Poi를 탭하면 발생. select시 Bus를 하이라이트하고 tracking한다.
    // 똑같은 Poi를 클릭했을 경우 unselect 처리를 위해 Bus 하이라이트와 tracking을 중지한다.
    func poiDidTapped(kakaoMap: KakaoMap, layerID: String, poiID: String, position: MapPoint) {
        
        if let layer = kakaoMap.getLabelManager().getLabelLayer(layerID: layerID) {
            // 해당 Poi를 클릭하기 전에 클릭했던 Poi를 가져와서, unselect처리
            if let unselected = layer.getPoi(poiID: _clickedPoi) {
                unselectPoi(mapView: kakaoMap, unselected: unselected)
                
                print("unselect \(_clickedPoi)")
            }
            
            if poiID != _clickedPoi {
                // 현재 클릭한 Poi를 가져와서 selected처리
                let selected = layer.getPoi(poiID: poiID)
                selectPoi(mapView: kakaoMap, selected: selected!)
                
                print("select \(poiID)")
                
                _clickedPoi = poiID
            }
            else {
                // 똑같은걸 탭했을때 unselect처리 후, 다음번에 다시 탭했을때 처리를 위해 임의의 키를 넣음
                _clickedPoi = "invalid"
            }
        }
    }
    
    // unselect 처리
    func unselectPoi(mapView: KakaoMap, unselected: Poi) {
        // shapeManager에서 animator와 하이라이트 Polygon을 가져온다.
        let shapeManager = mapView.getShapeManager()
        let animator = shapeManager.getShapeAnimator(animatorID: "circleWave_jejubus")
        
        let busColor = unselected.userObject as! String
        let circleWave = shapeManager.getShapeLayer(layerID: "polygon_circle_jejubus")?.getPolygonShape(shapeID: busColor)
        
        // Poi와 transform sharing을 중지한다. 하이라이트 폴리곤은 더이상 Poi를 따라가지 않는다.
        unselected.removeShareTransformWithShape(circleWave!)
        // 하이라이트 폴리곤의 애니메이션 효과를 중지한다.
        animator?.stop()
     
        // tracking모드를 중지한다.
        let trackingManager = mapView.getTrackingManager()
        trackingManager.stopTracking()
    }
    
    // select처리
    func selectPoi(mapView: KakaoMap, selected: Poi) {
        let shapeManager = mapView.getShapeManager()
        let trackingManager = mapView.getTrackingManager()
        trackingManager.startTrackingPoi(selected)
        
        // shapeManager에서 animator와 하이라이트 Polygon을 가져온다.
        let busColor = selected.userObject as! String
        let layer = shapeManager.getShapeLayer(layerID: "polygon_circle_jejubus")
        let animator = shapeManager.getShapeAnimator(animatorID: "circleWave_jejubus")
        let circleWave = layer?.getPolygonShape(shapeID: busColor)
        
        
        circleWave?.position = selected.position // 하이라이트 폴리곤의 위치를 현재 선택한 Poi위치로 업데이트
        selected.shareTransformWithShape(circleWave!) // 하이라이트 폴리곤을 선택한 Poi transform을 따라가도록 공유
        animator?.stop() // 애니메이터 효과를 다시 시작하기 위해 stop
        animator?.addPolygonShape(circleWave!) // 하이라이트 폴리곤을 애니메이터에 추가한다.
        animator?.start() // 애니메이터 시작.
    }
    
    var _buses: [String: Poi] = [String: Poi]()
    var _clickedPoi: String = ""
    var _jsonIndex: Int = 0
    var _timer: Timer?
    var _busTypes = [String: UIColor]()
}

