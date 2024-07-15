//
//  PoiClickServiceSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2020/08/18.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

class PoiClickServiceSample: APISampleBaseViewController, KakaoMapEventDelegate {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.02768, latitude: 37.498254)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        
        let mapView = mapController?.getView("mapview") as! KakaoMap
        mapView.eventDelegate = self
        
        createPoiLayer()
        createPoiStyles()
        
        createInfoWindow()
        createInfoWindowAnimator()
    }
    
    func createPoiLayer() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        let option = LabelLayerOptions(layerID: "example_click_service", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 100000)
        let _ = manager.addLabelLayer(option: option)
    }
    
    func createPoiStyles() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        let iconStyle = PoiIconStyle(symbol: UIImage(named: "search_ico_pin_map.png"), anchorPoint: CGPoint(x: 0.5, y: 0.999), transition: PoiTransition(entrance: .scale, exit: .scale))
        let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
        manager.addPoiStyle(PoiStyle(styleID: "label_clicked_style", styles: [perLevelStyle]))
        
        let smallIconStyle = PoiIconStyle(symbol: UIImage(named: "search_ico_pin_small_map.png"), anchorPoint: CGPoint(x: 0.5, y: 0.999), transition: PoiTransition(entrance: .scale, exit: .scale))
        let perLevelStyle2 = PerLevelPoiStyle(iconStyle: smallIconStyle, level: 0)
        manager.addPoiStyle(PoiStyle(styleID: "label_default_style", styles: [perLevelStyle2]))
    }
    
    func createInfoWindow() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let infoWindowLayer = mapView.getGuiManager().infoWindowLayer
        let infoWindow = InfoWindow("terrain_click_info_window")
        
        let tail = GuiImage("tail")
        tail.image = UIImage(named: "white_black.png")
        tail.origin = GuiAlignment(vAlign: .bottom, hAlign: .center)
        let body = GuiImage("body")
        body.image = UIImage(named: "white_black_round10.png")
        body.origin = GuiAlignment(vAlign: .bottom, hAlign: .center)
        body.align = GuiAlignment(vAlign: .top, hAlign: .left)
        body.imageStretch = GuiEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        infoWindow.tail = tail
        infoWindow.body = body
        infoWindow.bodyOffset.y = CGFloat((tail.image)!.size.height)
        infoWindow.bodyOffset.y = -infoWindow.bodyOffset.y + 4
        
        let vLayout = GuiLayout("vLayout")
        vLayout.arrangement = .vertical
        infoWindow.body?.child = vLayout
        
        let topLayout = GuiLayout("topLayout")
        topLayout.arrangement = .horizontal
        vLayout.addChild(topLayout)
        
        let bottomLayout = GuiLayout("bottomLayout")
        bottomLayout.arrangement = .horizontal
        vLayout.addChild(bottomLayout)
        
        let btn1 = GuiButton("bike")
        btn1.image = UIImage(named: "mapBtnBikeNormal@2x.png")
        btn1.align = GuiAlignment(vAlign: .bottom, hAlign: .center)
        let btn2 = GuiButton("bus")
        btn2.image = UIImage(named: "mapBtnBusNormal@2x.png")
        btn2.align = GuiAlignment(vAlign: .bottom, hAlign: .center)
        let btn3 = GuiButton("Cadastral")
        btn3.image = UIImage(named: "mapBtnCadastralNormal@2x.png")
        btn3.align = GuiAlignment(vAlign: .bottom, hAlign: .center)
        
        topLayout.addChild(btn1)
        topLayout.addChild(btn2)
        topLayout.addChild(btn3)
        
        let btn4 = GuiButton("landform")
        btn4.image = UIImage(named: "mapBtnLandformNormal@2x.png")
        btn4.align = GuiAlignment(vAlign: .bottom, hAlign: .center)
        let btn5 = GuiButton("cctv")
        btn5.image = UIImage(named: "mapBtnCctvNormal@2x.png")
        btn5.align = GuiAlignment(vAlign: .bottom, hAlign: .center)
        
        bottomLayout.addChild(btn4)
        bottomLayout.addChild(btn5)
        
        infoWindow.position = MapPoint(longitude: 127.027638, latitude: 37.49795)
        
        infoWindowLayer.addInfoWindow(infoWindow)
        _infoWindow = infoWindow
    }
    
    func createInfoWindowAnimator() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getGuiManager()
        let effect = DropAnimationEffect(pixelHeight: 100)
        effect.hideAtStop = false
        effect.interpolation = AnimationInterpolation(duration: 300, method: .cubicIn)
        effect.playCount = 1
        _animator = manager.addInfoWindowAnimator(animatorID: "infoWindow_drop_animator", effect: effect)
    }
    
    func poiDidTapped(kakaoMap: KakaoMap, layerID: String, poiID: String, position: MapPoint) {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        let layer = manager.getLabelLayer(layerID: layerID)
        if let poi = layer?.getPoi(poiID: poiID) {
            poi.hide()
            poi.changeStyle(styleID: "label_clicked_style")
            poi.show()
            
            if let clickedPoi = layer?.getPoi(poiID: _clickedPoiID) {
                clickedPoi.changeStyle(styleID: "label_default_style")
            }
            
            _clickedPoiID = poi.itemID
        }
    }
    
    func terrainDidTapped(kakaoMap: KakaoMap, position: MapPoint) {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "example_click_service")
        let option = PoiOptions(styleID: "label_default_style")
        option.clickable = true
        
        let poi = layer?.addPoi(option: option, at: position)
        poi?.showWithAutoMove()
    }
    
    func terrainDidLongPressed(kakaoMap: KakaoMap, position: MapPoint) {
        _infoWindow?.position = position
        _infoWindow?.show()
        
        _animator?.stop()
        _animator?.addInfoWindow(_infoWindow!)
        _animator?.start()
    }
    
    var _infoWindow: InfoWindow?
    var _animator: InfoWindowAnimator?
    var _clickedPoiID: String = ""
}
