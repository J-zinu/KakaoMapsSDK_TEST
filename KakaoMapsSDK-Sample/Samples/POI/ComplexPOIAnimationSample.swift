//
//  POIAnimationSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/05.
//  Copyright © 2020 kakao. All rights reserved.
//

import UIKit
import KakaoMapsSDK

// POI의 애니메이션 효과 예제.
class ComplexPOIAnimationSample: APISampleBaseViewController, KakaoMapEventDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        _upIndex = 0
        _downIndex = 0
        _rank = 0
        
        super.init(coder: aDecoder)
        
        createPoiAnimationEffect()
    }
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        let view = mapController?.getView("mapview") as! KakaoMap
        view.eventDelegate = self
        
        createLabelLayer()
        createPoiStyle()
    }
    
    func createLabelLayer() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let layerOption = LabelLayerOptions(layerID: "PoiTestLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
        let manager = view.getLabelManager()
        let _ = manager.addLabelLayer(option: layerOption)
    }
    
    func createPoiStyle() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        
        let icon = PoiIconStyle(symbol: UIImage(named: "pin_green.png"), anchorPoint: CGPoint(x: 0.5, y: 1.0), transition: PoiTransition(entrance: .none, exit: .none))
        let perLevelStyle1 = PerLevelPoiStyle(iconStyle: icon, level: 0)
        let poiStyle1 = PoiStyle(styleID: "customStyle1", styles: [perLevelStyle1])
        
        manager.addPoiStyle(poiStyle1)
        
        let icon2 = PoiIconStyle(symbol: UIImage(named: "circle.png"), anchorPoint: CGPoint(x: 0.5, y: 0.5), transition: PoiTransition(entrance: .none, exit: .none))
        let perLevelStyle2 = PerLevelPoiStyle(iconStyle: icon2, level: 0)
        let poiStyle2 = PoiStyle(styleID: "customStyle2", styles: [perLevelStyle2])
        
        manager.addPoiStyle(poiStyle2)
    }
    
    func createPoiAnimationEffect() {
        _upEffect = ScaleAlphaAnimationEffect()
        _upEffect!.hideAtStop = false
        _upEffect!.removeAtStop = false
        
        let keyframe1 = ScaleAlphaAnimationKeyFrame(scale: Vector2(x: 0.1, y: 0.1), alpha: 0.0, interpolation: AnimationInterpolation(duration: 0, method: .cubicOut))
        let keyframe2 = ScaleAlphaAnimationKeyFrame(scale: Vector2(x: 1.0, y: 1.0), alpha: 1.0, interpolation: AnimationInterpolation(duration: 1000, method: .cubicOut))
        _upEffect!.addKeyframe(keyframe1)
        _upEffect!.addKeyframe(keyframe2)
        
        _downEffect = ScaleAlphaAnimationEffect()
        _downEffect!.hideAtStop = true
        _downEffect!.removeAtStop = true
        
        let downKeyframe = ScaleAlphaAnimationKeyFrame(scale: Vector2(x: 0.1, y: 0.1), alpha: 0.0, interpolation: AnimationInterpolation(duration: 1000, method: .cubicOut))
        _downEffect!.addKeyframe(downKeyframe)
        
        _waveEffect = ScaleAlphaAnimationEffect()
        _waveEffect!.hideAtStop = true
        _waveEffect!.removeAtStop = true
        
        let waveKeyFrame1 = ScaleAlphaAnimationKeyFrame(scale: Vector2(x: 0.1, y: 0.1), alpha: 0.0, interpolation: AnimationInterpolation(duration: 0, method: .cubicOut))
        let waveKeyFrame2 = ScaleAlphaAnimationKeyFrame(scale: Vector2(x: 1.0, y: 1.0), alpha: 0.4, interpolation: AnimationInterpolation(duration: 500, method: .cubicOut))
        let waveKeyFrame3 = ScaleAlphaAnimationKeyFrame(scale: Vector2(x: 0.1, y: 0.1), alpha: 0.0, interpolation: AnimationInterpolation(duration: 500, method: .cubicOut))
        let waveKeyFrame4 = ScaleAlphaAnimationKeyFrame(scale: Vector2(x: 1.0, y: 1.0), alpha: 0.4, interpolation: AnimationInterpolation(duration: 500, method: .cubicOut))
        let waveKeyFrame5 = ScaleAlphaAnimationKeyFrame(scale: Vector2(x: 0.1, y: 0.1), alpha: 0.0, interpolation: AnimationInterpolation(duration: 500, method: .cubicOut))
        
        _waveEffect?.addKeyframe(waveKeyFrame1)
        _waveEffect?.addKeyframe(waveKeyFrame2)
        _waveEffect?.addKeyframe(waveKeyFrame3)
        _waveEffect?.addKeyframe(waveKeyFrame4)
        _waveEffect?.addKeyframe(waveKeyFrame5)
    }
    
    func createPoi(position: MapPoint, hide: Bool) {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiTestLayer")
        let poiOption = PoiOptions(styleID: "customStyle1")
        poiOption.rank = _rank
        poiOption.clickable = true
        _rank += 1
        
        let poi = layer?.addPoi(option:poiOption, at: position)
        poi!.show()
        
        let waveOption = PoiOptions(styleID: "customStyle2")
        waveOption.rank = _rank - 1
        waveOption.clickable = false
        
        let wave = layer?.addPoi(option:waveOption, at: position)
        wave!.show()
        
        let scaleUpAnimator = manager.addPoiAnimator(animatorID: "scaleUp_\(_upIndex)", effect: _upEffect!)
        let waveAnimator = manager.addPoiAnimator(animatorID: "wave_\(_upIndex)", effect: _waveEffect!)
                
        _upIndex += 1
        
        scaleUpAnimator?.addPoi(poi!)
        scaleUpAnimator?.start()
        waveAnimator?.addPoi(wave!)
        waveAnimator?.start()
    }
    
    func terrainDidTapped(kakaoMap: KakaoMapsSDK.KakaoMap, position: KakaoMapsSDK.MapPoint) {
        createPoi(position: position, hide: false)
    }
    
    func terrainDidLongPressed(kakaoMap: KakaoMap, position: MapPoint) {
        createPoi(position: position, hide: false)
    }
    
    func poiDidTapped(kakaoMap: KakaoMap, layerID: String, poiID: String, position: MapPoint) {
        let manager = kakaoMap.getLabelManager()
        if layerID == "PoiTestLayer" {
            let scaleDownAnimator = manager.addPoiAnimator(animatorID: "scaleDown_\(_downIndex)", effect: _downEffect!)
            _downIndex += 1
            let poi = kakaoMap.getLabelManager().getLabelLayer(layerID: layerID)?.getPoi(poiID: poiID)
            scaleDownAnimator?.addPoi(poi!)
            scaleDownAnimator?.start()
        }
    }
    
    var _upIndex: Int
    var _rank: Int
    var _downIndex: Int
    var _upEffect: ScaleAlphaAnimationEffect?
    var _downEffect: ScaleAlphaAnimationEffect?
    var _waveEffect: ScaleAlphaAnimationEffect?
}
