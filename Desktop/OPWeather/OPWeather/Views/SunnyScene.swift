
import SpriteKit

class SunnyScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .clear

        // 太陽のスプライトを作成
        let sunTexture = SKTexture(imageNamed: "Sun")
        let sunNode = SKSpriteNode(texture: sunTexture)
        
        sunNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        sunNode.size = CGSize(width: 200, height: 200)
        addChild(sunNode)

        // 回転アクション
        let rotateAction = SKAction.rotate(byAngle: .pi, duration: 20)
        let repeatAction = SKAction.repeatForever(rotateAction)
        sunNode.run(repeatAction)
    }
}
