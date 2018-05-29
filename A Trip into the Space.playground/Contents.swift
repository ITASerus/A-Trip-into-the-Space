//#-hidden-code
import SpriteKit
import PlaygroundSupport

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 375, height: 667))

//Create Scene
let scene = GameScene(size: sceneView.frame.size)
// Set the scale mode to scale to fit the window
scene.scaleMode = .aspectFit

// Present the scene
sceneView.presentScene(scene)

sceneView.ignoresSiblingOrder = true

sceneView.showsFPS = false
sceneView.showsNodeCount = false
sceneView.showsPhysics = false

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
//#-end-hidden-code

/*:
 [flagofplanetearth.com]: http://www.flagofplanetearth.com
 # A Trip into the Space
 ### by Ernesto De Crecchio
 
 _Space_... what we know about it? A lot and at same time nothing.
 
 After the "space race" has started, humanity has pointed a lot in this topic to try to send humans in space and to learn informationa about things that are distant hundreds of light years and that, hopefully, we will reach sooner or later.
 
 
 This playgound is basically a game where you pilot a space shuttle and you mission is to reach Mars, the Red Planet!
 The trip is very dangerous and you will meet a lot of difficulties like satellites and asteroids. Moreover you need to stay in the right trajectory of course, or you trip will become longer that expected (going into the deep space is not funny ;) )
 
 Different obstacles will bring to different "game over" types that will try to teach you some curiosity about the universe and how spaceman and scientists work together!
 
 
 The shuttle that you will drive represent the entire Earth, infact on the right wing there is the Earth's flag by Oskar Pernefeldt (more info on [flagofplanetearth.com])
 
 ![Flag](International_Flag_of_Planet_Earth.png)
 
 ## How to play:
 Use the slider to set the shuttle velocity and tap on the engines to go left or right (the left engine will push the shuttle on the right and viceversa)
*/

