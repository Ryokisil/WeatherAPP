//
//  RainScene.swift
//  OPWeather
//
//  Created by silvia on 2024/06/24.
//

import SpriteKit

// RainSceneクラスは、SKSceneを継承したクラスで、雨のアニメーションを表示するためのもの
class RainScene: SKScene {
    // SKViewがこのシーンを表示したときに呼び出されるメソッド
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        // 雨のアニメーションを作成するメソッドを呼び出す
        createRain()
    }
    
    // 雨のアニメーションを作成するメソッド
    func createRain() {
        // SKEmitterNodeをRainFall.sksファイルから読み込む
        guard let rainNode = SKEmitterNode(fileNamed: "RainFall.sks") else { return }
        // rainNodeの位置をシーンの上部中央に設定
        rainNode.position = CGPoint(x: size.width / 2, y: size.height)
        // rainNodeの粒子がシーン全体に広がるように設定
        rainNode.particlePositionRange = CGVector(dx: size.width, dy: 0)
        // シーンにrainNodeを追加
        addChild(rainNode)
    }
}

