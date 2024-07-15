//
//  SharedLocationSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2020/08/13.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

class SharedLocationSample: APISampleBaseViewController, GuiEventDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        _mode = .hidden
        super.init(coder: aDecoder)
    }
    
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
        
        createCurrentPositionMarker()
        createSpriteGui()
        
        createLayer()
        createSharedLocationStyle()
        createBadgesTable()
        createSharedLocationPois()
    }
    
// MARK: CurrentPosition Marker
    
    func createCurrentPositionMarker() {
        createPoiLayer()
        createLocationMarkerStyles()
        createLocationMarkerPois()
        createCircleWaveAnimation()
    }
    
    func createSpriteGui() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let spriteLayer = mapView.getGuiManager().spriteGuiLayer
        let spriteGui = SpriteGui("buttonGui")
        spriteGui.bgColor = UIColor.clear
        spriteGui.origin = GuiAlignment(vAlign: .bottom, hAlign: .right)
     
        let button = GuiButton("CPB")
        button.image = UIImage(named: "track_location_btn.png")
        
        spriteGui.addChild(button)
        spriteLayer.addSpriteGui(spriteGui)
        spriteGui.delegate = self
        spriteGui.show()
    }
    
    func guiDidTapped(_ gui: GuiBase, componentName: String) {
        let button = gui.getChild(componentName) as! GuiButton
        switch _mode {
        case .hidden:
            _mode = .show
            button.image = UIImage(named: "track_location_btn_pressed.png")
            _locationPoi?.show()
            _directionPoi?.show()
            _directionAreaPoi?.show()
            startAnimator()
            _timer = Timer.init(timeInterval: 0.15, target: self, selector: #selector(self.onUpdateCurrentLocation), userInfo: nil, repeats: true)
            RunLoop.current.add(_timer!, forMode: RunLoop.Mode.common)
            
            _locationPoi?.shareTransformWithPoi(_mePoi!)
        case .show:
            _mode = .tracking
            button.image = UIImage(named: "track_location_btn_compass_on.png")
            let mapView = mapController?.getView("mapview") as! KakaoMap
            let trackingManager = mapView.getTrackingManager()
            trackingManager.startTrackingPoi(_directionPoi!)
            _directionPoi?.show()
            _directionAreaPoi?.hide()
        case .tracking:
            _mode = .hidden
            _timer?.invalidate()
            _timer = nil
            button.image = UIImage(named: "track_location_btn.png")
            _locationPoi?.hide()
            _directionPoi?.hide()
            let mapView = mapController?.getView("mapview") as! KakaoMap
            let trackingManager = mapView.getTrackingManager()
            trackingManager.stopTracking()
            
            _locationPoi?.removeShareTransformWithPoi(_mePoi!)
        }
        
        gui.updateGui()
    }
    
    func createPoiLayer() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        
        // position marker layer
        let positionLayerOption = LabelLayerOptions(layerID: "current_position_layer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 11000)
        let _ = manager.addLabelLayer(option: positionLayerOption)
        
        // direction marker layer
        let directionLayerOption = LabelLayerOptions(layerID: "direction_layer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 11100)
        let _ = manager.addLabelLayer(option: directionLayerOption)
    }
    
    func createLocationMarkerStyles() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        
        // location marker style
        let locationStyle = PerLevelPoiStyle(iconStyle: PoiIconStyle(symbol: UIImage(named: "map_ico_marker.png")), level: 0)
        manager.addPoiStyle(PoiStyle(styleID: "locationPoiStyle", styles: [locationStyle]))
        
        // direction marker style
        let direction = PoiIconStyle(symbol: UIImage(named: "map_ico_marker_direction.png"), anchorPoint: CGPoint(x: 0.5, y: 0.995))
        let directionStyle = PerLevelPoiStyle(iconStyle: direction, level: 0)
        manager.addPoiStyle(PoiStyle(styleID: "directionPoiStyle", styles: [directionStyle]))
        
        // area marker style
        let area = PoiIconStyle(symbol: UIImage(named: "map_ico_direction_area.png"), anchorPoint: CGPoint(x: 0.5, y: 0.995))
        let directionAreaStyle = PerLevelPoiStyle(iconStyle: area, level: 0)
        manager.addPoiStyle(PoiStyle(styleID: "directionAreaPoiStyle", styles: [directionAreaStyle]))
    }
    
    func createLocationMarkerPois() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        let locationLayer = manager.getLabelLayer(layerID: "current_position_layer")
        let directionLayer = manager.getLabelLayer(layerID: "direction_layer")
        
        let position = MapPoint(longitude: 127.031894, latitude: 37.519763)
        
        // location Poi
        let option1 = PoiOptions(styleID: "locationPoiStyle", poiID: "location_poi")
        option1.rank = 1
        option1.transformType = .absoluteRotationDecal
        let locationPoi = locationLayer?.addPoi(option: option1, at: position)
        
        let option2 = PoiOptions(styleID: "directionPoiStyle", poiID: "direction_poi")
        option2.rank = 3
        option2.transformType = .absoluteRotationDecal
        let directionPoi = directionLayer?.addPoi(option: option2, at: position)
        
        let option3 = PoiOptions(styleID: "directionAreaPoiStyle", poiID: "direction_area_poi")
        option3.rank = 2
        option3.transformType = .absoluteRotationDecal
        let directionAreaPoi = directionLayer?.addPoi(option: option3, at: position)
        
        locationPoi?.shareTransformWithPoi(directionPoi!)
        directionPoi?.shareTransformWithPoi(directionAreaPoi!)
        
        _locationPoi = locationPoi
        _directionPoi = directionPoi
        _directionAreaPoi = directionAreaPoi
    }
    
    func createCircleWaveAnimation() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        let layer = manager.addShapeLayer(layerID: "circleWave", zOrder: 10001)
        
        // Style 생성
        let shapeStyle = PolygonStyle(styles: [
            PerLevelPolygonStyle(color: UIColor(hex: 0x50bcdfff), level: 0)
        ])
        let styleSet = PolygonStyleSet(styleSetID: "circleWave_style", styles: [shapeStyle])
        manager.addPolygonStyleSet(styleSet)
        
        // PolygonShape 생성
        let option = PolygonShapeOptions(shapeID: "circleWave", styleID: "circleWave_style", zOrder: 0)
        option.basePosition = MapPoint(longitude: 127.044395, latitude: 37.505754)
        option.polygons.append(Polygon(exteriorRing: Primitives.getCirclePoints(radius: 1, numPoints: 90, cw: true), hole: nil, styleIndex: 0))
        
        let circleWave = layer?.addPolygonShape(option)
        _waveShape = circleWave
        
        // animator 추가
        let waveEffect = WaveAnimationEffect(datas: [
            WaveAnimationData(startAlpha: 0.8, endAlpha: 0.0, startRadius: 10.0, endRadius: 100.0, level: 0)
        ])
        waveEffect.hideAtStop = true
        waveEffect.interpolation = AnimationInterpolation(duration: 1000, method: .cubicOut)
        waveEffect.playCount = 5
        
        _animator = manager.addShapeAnimator(animatorID: "circleWave_animator", effect: waveEffect)
    
        _locationPoi?.shareTransformWithShape(circleWave!)
    }
    
    func startAnimator() {
        _waveShape?.position = _locationPoi!.position
        _animator?.stop()
        _animator?.addPolygonShape(_waveShape!)
        _animator?.start()
    }
    
    @objc func onUpdateCurrentLocation() {
        if let position = _locationPoi?.position {
            let delta = Double.random(in: 0...0.000089)
            
            _locationPoi?.moveAt(MapPoint(longitude: position.wgsCoord.longitude + delta,
                                          latitude: position.wgsCoord.latitude + delta), duration: 1500)
        }
    }
    
// MARK: Shared Location
    func createLayer() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        // zOrder값을 조절해서 CurrentPositionMarker를 구성하는 location poi, direction area, direction poi와의 렌더링 순서를 조절한다.
        let option = LabelLayerOptions(layerID: "example_shared_map", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 11010)
        let _ = manager.addLabelLayer(option: option)
    }
    
    func createSharedLocationStyle() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        
        let anchor = CGPoint(x: 0.5, y: 0.995)
        let transition = PoiTransition(entrance: .scale, exit: .scale)
        
        let defaultBadges = [
            PoiBadge(badgeID: "shared_map_crown", image: UIImage(named: "sharemap_marker_crown_badge_normal.png"), offset: CGPoint(x: 0.1, y: 0.6), zOrder: 1),
            PoiBadge(badgeID: "shared_map_me", image: UIImage(named: "Sharemap_marker_me_badge_normal.png"), offset: CGPoint(x: 0.1, y: 0.6), zOrder: 2),
            PoiBadge(badgeID: "shared_map_bad", image: UIImage(named: "Sharemap_marker_bad_badge_normal.png"), offset: CGPoint(x: 0.9, y: 0), zOrder: 3)
        ]
        let defaultIcon = PoiIconStyle(symbol: UIImage(named: "Sharemap_marker_nomal.png"), anchorPoint: anchor, transition: transition, badges: defaultBadges)
        let perLevelDefault = PerLevelPoiStyle(iconStyle: defaultIcon, level: 0)
        
        let bigBadges = [
            PoiBadge(badgeID: "shared_map_crown", image: UIImage(named: "Sharemap_marker_crown_badge_big.png"), offset: CGPoint(x: 0.1, y: 0.6), zOrder: 1),
            PoiBadge(badgeID: "shared_map_me", image: UIImage(named: "Sharemap_marker_me_badge_big.png"), offset: CGPoint(x: 0.1, y: 0.6), zOrder: 2),
            PoiBadge(badgeID: "shared_map_bad", image: UIImage(named: "Sharemap_marker_bad_badge_big.png"), offset: CGPoint(x: 0.9, y: 0.6), zOrder: 3)
        ]
        let bigIcon = PoiIconStyle(symbol: UIImage(named: "Sharemap_marker_big.png"), anchorPoint: anchor, transition: transition, badges: bigBadges)
        let perLevelBig = PerLevelPoiStyle(iconStyle: bigIcon, level: 0)

        manager.addPoiStyle(PoiStyle(styleID: "shared_map_default", styles: [perLevelDefault]))
        manager.addPoiStyle(PoiStyle(styleID: "shared_map_big", styles: [perLevelBig]))
    }
    
    func createBadgesTable() {
        // 마커 위에 표시하는 개별 프로필 뱃지를 생성한다.
        
        let defaultImage = "Profile_default_"
        let bigImage = "Profile_big_"
        let offset = CGPoint(x: 0.5, y: 0.4)
        
        for index in 1 ... 10 {
            let id = index >= 10 ? String(index):("0"+String(index))
            
            let badge = PoiBadge(badgeID: id, image: UIImage(named: defaultImage+id+".png")!, offset: offset, zOrder: 0)
            let bigBadge = PoiBadge(badgeID: id+"_big", image: UIImage(named: bigImage+id+".png")!, offset: offset, zOrder: 0)
            
            _badgesTable[badge.badgeID] = badge
            _badgesTable[bigBadge.badgeID] = bigBadge
        }
    }
    
    func createSharedLocationPois() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "example_shared_map")

        let positions = [
            CartesianCoordinate(x: 197998, y: 451196),
            CartesianCoordinate(x: 197182, y: 450352),
            CartesianCoordinate(x: 198420, y: 446330),
            CartesianCoordinate(x: 199834, y: 444850),
            CartesianCoordinate(x: 199138, y: 444770),
            CartesianCoordinate(x: 199708, y: 444808),
            CartesianCoordinate(x: 194960, y: 442894),
            CartesianCoordinate(x: 199418, y: 441676),
            CartesianCoordinate(x: 203042, y: 444598),
            CartesianCoordinate(x: 204324, y: 445200)
        ]
        
        var points = [MapPoint]()
        for position in positions {
            let coord = MapCoordConverter.fromWTMToWGS84(wtm: position)
            points.append(MapPoint(longitude: coord.longitude, latitude: coord.latitude))
        }
        
        var options = [PoiOptions]()
        var rank: Int = 0
        for index in 1 ... 10 {
            let id = index >= 10 ? String(index):("0"+String(index))
            
            let option = PoiOptions(styleID: "shared_map_default", poiID: id)
            option.rank = Int(rank)
            option.clickable = true
            rank += 1
            
            options.append(option)
        }
        
        if let pois = layer?.addPois(options: options, at: points) {
            var index = 1
            for poi in pois {
                // 여기서 뱃지를 추가하자.
                let id = index >= 10 ? String(index):("0"+String(index))
                poi.addBadge(_badgesTable[id]!)
                poi.show()
                poi.showBadge(badgeID: "Profile_default_"+poi.itemID)
                
                if _me == poi.itemID {
                    _mePoi = poi
                }
                else {
                    poi.hideStyleBadge(badgeID: "shared_map_me")
                }
                
                if _crown != poi.itemID {
                    poi.hideStyleBadge(badgeID: "shared_map_crown")
                }
                
                index += 1
            }
        }
        
        mapView.moveCamera(CameraUpdate.make(area: AreaRect(points: points)))
    }

    let _me = "02"
    let _crown = "08"
    var _badgesTable: [String: PoiBadge] = [String: PoiBadge]()
    var _mePoi: Poi?
    var _locationPoi: Poi?
    var _directionPoi: Poi?
    var _directionAreaPoi: Poi?
    var _waveShape: PolygonShape?
    var _animator: ShapeAnimator?
    var _mode: Mode
    var _timer: Timer?
}
