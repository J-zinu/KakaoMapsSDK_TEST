//
//  PoiTransitionSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/09/28.
//  Copyright © 2021 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

class PoiTransitionSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition = pos1
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        
        let _ = manager.addLabelLayer(option: LabelLayerOptions(layerID: "layer_1", competitionType: .none, competitionUnit: .poi, orderType: .rank, zOrder: 10001))
        
        createPois(iconEntrance: _iconEntranceEnabled, iconExit: _iconExitEnabled, textEntrance: _textEntranceEnabled, textExit: _textExitEnabled)
    }
    
    // enableTransition 여부에 따라 스타일을 생성.
    // 레벨 변경에 의해 스타일이 바뀔 때, transition 변화를 확인할 수 있음.
    func createPoiStyles(iconEntrance: Bool, iconExit: Bool, textEntrance: Bool, textExit: Bool) {
        
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        
        /// 첫번째 스타일 생성
        
        // 0~14 레벨스타일.
        // iconTransition: alpha
        let iconStyle1 = PoiIconStyle(symbol: UIImage(named: "p_eat_dot@2x.png"),
                                      anchorPoint: CGPoint(x: 0.5, y: 0.5),
                                      transition: PoiTransition(entrance: .alpha, exit: .alpha),
                                      enableEntranceTransition: iconEntrance,
                                      enableExitTransition: iconExit,
                                      badges: nil)
        let perLevelStyle1 = PerLevelPoiStyle(iconStyle: iconStyle1, level: 0)
        
        // 15~ 레벨 스타일.
        // iconTransition: Scale
        // textTransition: Alpha
        let iconStyle2 = PoiIconStyle(symbol: UIImage(named: "pin_red.png"),
                                      anchorPoint: CGPoint(x: 0.5, y: 0.99), transition: PoiTransition(entrance: .scale, exit: .scale),
                                      enableEntranceTransition: iconEntrance,
                                      enableExitTransition: iconExit,
                                      badges: nil)

        let textLineStyle = PoiTextLineStyle(textStyle:
                                                TextStyle(fontSize: 15, fontColor: UIColor(hex: 0xffffffff), strokeThickness: 2, strokeColor: UIColor(hex: 0x333333ff)))
        let textStyle2 = PoiTextStyle(transition: PoiTransition(entrance: .alpha, exit: .alpha),
                                      enableEntranceTransition: textEntrance,
                                      enableExitTransition: textExit,
                                      textLineStyles: [textLineStyle])
        textStyle2.textLayouts = [.bottom]
        let perLevelStyle2 = PerLevelPoiStyle(iconStyle: iconStyle2, textStyle: textStyle2, level: 15)
        
        // perLevelStyle1(0~14) & perLevelStyle2(15~)로 이루어진 스타일 생성
        let style1 = PoiStyle(styleID: "style_" + String(_numStyles), styles: [perLevelStyle1, perLevelStyle2])
        manager.addPoiStyle(style1)
        
        _numStyles = _numStyles + 1
        
        /// 두번째 스타일 생성
        
        // 0~14 레벨스타일.
        // iconTransition: alpha
        let iconStyle3 = PoiIconStyle(symbol: UIImage(named: "mapIcoBookmark_02.png"),
                                      anchorPoint: CGPoint(x: 0.5, y: 0.5),
                                      transition: PoiTransition(entrance: .alpha, exit: .alpha),
                                      enableEntranceTransition: iconEntrance,
                                      enableExitTransition: iconExit,
                                      badges: nil)
        let perLevelStyle3 = PerLevelPoiStyle(iconStyle: iconStyle3, level: 0)
        
        // 15~ 레벨스타일.
        // iconTransition: Alpha
        // textTransition: Alpha
        let iconStyle4 = PoiIconStyle(symbol: UIImage(named: "mapIcoBookmark_02.png"),
                                      anchorPoint: CGPoint(x: 0.5, y: 0.5),
                                      transition: PoiTransition(entrance: .alpha, exit: .alpha),
                                      enableEntranceTransition: iconEntrance,
                                      enableExitTransition: iconExit,
                                      badges: nil)
        let textLineStyle2 = PoiTextLineStyle(textStyle: TextStyle(fontSize: 15, fontColor: UIColor(hex: 0xffffffff), strokeThickness: 2, strokeColor: UIColor(hex: 0x333333ff)))
        let textStyle4 = PoiTextStyle(transition: PoiTransition(entrance: .alpha, exit: .alpha),
                                      enableEntranceTransition: textEntrance,
                                      enableExitTransition: textExit,
                                      textLineStyles: [textLineStyle2])
        textStyle4.textLayouts = [.bottom]
        let perLevelStyle4 = PerLevelPoiStyle(iconStyle: iconStyle4, textStyle: textStyle4, level: 15)
        
        let style2 = PoiStyle(styleID: "style_" + String(_numStyles), styles: [perLevelStyle3, perLevelStyle4])
        manager.addPoiStyle(style2)
        
        _numStyles = _numStyles + 1
    }
    
    func createPois(iconEntrance: Bool, iconExit: Bool, textEntrance: Bool, textExit: Bool) {
        createPoiStyles(iconEntrance: iconEntrance,
                        iconExit: iconExit,
                        textEntrance: textEntrance,
                        textExit: textExit)
        
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "layer_1")
        layer?.clearAllItems()
        
        
        let option1 = PoiOptions(styleID: "style_" + String((_numStyles-2)))
        option1.addText(PoiText(text: "Poi1 테스트", styleIndex: 0))
        let _ = layer?.addPoi(option: option1, at: pos1)
        
        let option2 = PoiOptions(styleID: "style_" + String(_numStyles-1))
        option2.addText(PoiText(text: "Poi2 테스트", styleIndex: 0))
        let _ = layer?.addPoi(option: option2, at: pos2)
        
        layer?.showAllPois()
    }
    
    @IBAction func onIconEntranceSwitch(_ sender: Any) {
        _iconEntranceEnabled = (sender as! UISwitch).isOn
        
        createPois(iconEntrance: _iconEntranceEnabled, iconExit: _iconExitEnabled, textEntrance: _textEntranceEnabled, textExit: _textExitEnabled)
    }
    
    @IBAction func onIconExitSwith(_ sender: Any) {
        _iconExitEnabled = (sender as! UISwitch).isOn
        
        createPois(iconEntrance: _iconEntranceEnabled, iconExit: _iconExitEnabled, textEntrance: _textEntranceEnabled, textExit: _textExitEnabled)
    }
    
    
    @IBAction func onTextEntranceSwitch(_ sender: Any) {
        _textEntranceEnabled = (sender as! UISwitch).isOn
        
        createPois(iconEntrance: _iconEntranceEnabled, iconExit: _iconExitEnabled, textEntrance: _textEntranceEnabled, textExit: _textExitEnabled)
    }
    
    
    @IBAction func onTextExitSwitch(_ sender: Any) {
        _textExitEnabled = (sender as! UISwitch).isOn
        
        createPois(iconEntrance: _iconEntranceEnabled, iconExit: _iconExitEnabled, textEntrance: _textEntranceEnabled, textExit: _textExitEnabled)
    }
    
    var _numStyles = 0
    var _iconEntranceEnabled: Bool = true
    var _iconExitEnabled: Bool = true
    var _textEntranceEnabled: Bool = true
    var _textExitEnabled: Bool = true
 
    let pos1 = MapPoint(longitude: 127.108678, latitude: 37.402001)
    let pos2 = MapPoint(longitude: 127.107465, latitude: 37.402009)
}
