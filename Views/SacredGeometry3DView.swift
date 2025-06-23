/**
 * Filename: SacredGeometry3DView.swift
 * 
 * Purpose: Creates stunning 3D sacred geometry using SceneKit with procedural generation
 * Features mathematically precise 3D platonic solids, sacred polyhedra, and mystical forms
 * 
 * Design pattern: SceneKit-based 3D rendering with custom geometry generation
 * Dependencies: SceneKit, Foundation
 */

import SwiftUI
import SceneKit

/**
 * 3D Sacred Geometry view that creates breathtaking three-dimensional sacred forms
 * using procedural generation and mathematical precision.
 */
struct SacredGeometry3DView: UIViewRepresentable {
    let number: Int
    let animationSpeed: Double
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        
        // Create scene
        let scene = SCNScene()
        sceneView.scene = scene
        
        // Configure scene view
        sceneView.backgroundColor = UIColor.clear
        sceneView.allowsCameraControl = false
        sceneView.autoenablesDefaultLighting = false
        sceneView.antialiasingMode = .multisampling4X
        
        // Add sacred geometry
        let geometryNode = createSacredGeometry3D(for: number)
        scene.rootNode.addChildNode(geometryNode)
        
        // Add ethereal lighting
        setupSacredLighting(scene: scene, number: number)
        
        // Add camera
        setupCamera(scene: scene)
        
        // Start mystical animations
        startSacredAnimations(node: geometryNode, speed: animationSpeed)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update animation speed if needed
        if let geometryNode = uiView.scene?.rootNode.childNodes.first {
            updateAnimationSpeed(node: geometryNode, speed: animationSpeed)
        }
    }
    
    // MARK: - 3D Sacred Geometry Generation
    
    private func createSacredGeometry3D(for number: Int) -> SCNNode {
        let containerNode = SCNNode()
        
        switch number {
        case 1:
            containerNode.addChildNode(createUnity3D())
        case 2:
            containerNode.addChildNode(createVesicaPiscis3D())
        case 3:
            containerNode.addChildNode(createTetrahedron())
        case 4:
            containerNode.addChildNode(createCube())
        case 5:
            containerNode.addChildNode(createDodecahedron())
        case 6:
            containerNode.addChildNode(createMerkaba3D())
        case 7:
            containerNode.addChildNode(createSeedOfLife3D())
        case 8:
            containerNode.addChildNode(createOctahedron())
        case 9:
            containerNode.addChildNode(createIcosahedron())
        default:
            containerNode.addChildNode(createUnity3D())
        }
        
        return containerNode
    }
    
    // MARK: - Sacred Geometry Shapes
    
    private func createUnity3D() -> SCNNode {
        let node = SCNNode()
        
        // Central sphere (unity)
        let sphere = SCNSphere(radius: 0.8)
        let sphereNode = SCNNode(geometry: sphere)
        
        // Create concentric energy shells
        for i in 1...7 {
            let shellRadius = 0.8 + (Double(i) * 0.3)
            let shell = SCNSphere(radius: shellRadius)
            let shellNode = SCNNode(geometry: shell)
            
            // Wireframe material for energy shells
            let material = SCNMaterial()
            material.fillMode = .lines
            material.diffuse.contents = getSacredColor(for: 1).withAlphaComponent(0.3 / Double(i))
            shell.materials = [material]
            
            node.addChildNode(shellNode)
        }
        
        // Solid core material
        let coreMaterial = SCNMaterial()
        coreMaterial.diffuse.contents = getSacredColor(for: 1)
        coreMaterial.emission.contents = getSacredColor(for: 1).withAlphaComponent(0.5)
        sphere.materials = [coreMaterial]
        
        node.addChildNode(sphereNode)
        return node
    }
    
    private func createVesicaPiscis3D() -> SCNNode {
        let node = SCNNode()
        
        // Two intersecting spheres
        let sphere1 = SCNSphere(radius: 1.0)
        let sphere2 = SCNSphere(radius: 1.0)
        
        let node1 = SCNNode(geometry: sphere1)
        let node2 = SCNNode(geometry: sphere2)
        
        // Position spheres to create vesica piscis
        node1.position = SCNVector3(-0.6, 0, 0)
        node2.position = SCNVector3(0.6, 0, 0)
        
        // Semi-transparent materials
        let material1 = SCNMaterial()
        material1.diffuse.contents = getSacredColor(for: 2).withAlphaComponent(0.7)
        material1.emission.contents = getSacredColor(for: 2).withAlphaComponent(0.3)
        sphere1.materials = [material1]
        
        let material2 = SCNMaterial()
        material2.diffuse.contents = getSacredColor(for: 2).withAlphaComponent(0.7)
        material2.emission.contents = getSacredColor(for: 2).withAlphaComponent(0.3)
        sphere2.materials = [material2]
        
        node.addChildNode(node1)
        node.addChildNode(node2)
        
        return node
    }
    
    private func createTetrahedron() -> SCNNode {
        // Create tetrahedron using custom geometry
        let vertices: [SCNVector3] = [
            SCNVector3(0, 1, 0),           // top
            SCNVector3(-0.866, -0.5, 0.5), // bottom left
            SCNVector3(0.866, -0.5, 0.5),  // bottom right
            SCNVector3(0, -0.5, -1)        // bottom back
        ]
        
        let indices: [UInt16] = [
            0, 1, 2,  // front face
            0, 2, 3,  // right face
            0, 3, 1,  // left face
            1, 3, 2   // bottom face
        ]
        
        return createCustomGeometry(vertices: vertices, indices: indices, number: 3)
    }
    
    private func createCube() -> SCNNode {
        let box = SCNBox(width: 1.5, height: 1.5, length: 1.5, chamferRadius: 0.1)
        let node = SCNNode(geometry: box)
        
        // Sacred cube material
        let material = SCNMaterial()
        material.diffuse.contents = getSacredColor(for: 4)
        material.emission.contents = getSacredColor(for: 4).withAlphaComponent(0.4)
        material.metalness.contents = 0.8
        material.roughness.contents = 0.2
        box.materials = [material]
        
        // Add wireframe overlay
        let wireframe = SCNBox(width: 1.6, height: 1.6, length: 1.6, chamferRadius: 0)
        let wireframeNode = SCNNode(geometry: wireframe)
        let wireframeMaterial = SCNMaterial()
        wireframeMaterial.fillMode = .lines
        wireframeMaterial.diffuse.contents = getSacredColor(for: 4).withAlphaComponent(0.8)
        wireframe.materials = [wireframeMaterial]
        
        node.addChildNode(wireframeNode)
        return node
    }
    
    private func createDodecahedron() -> SCNNode {
        // Golden ratio for perfect dodecahedron
        let phi = (1.0 + sqrt(5.0)) / 2.0
        let invPhi = 1.0 / phi
        
        // 20 vertices of dodecahedron
        let vertices: [SCNVector3] = [
            // Cube vertices
            SCNVector3(1, 1, 1), SCNVector3(1, 1, -1), SCNVector3(1, -1, 1), SCNVector3(1, -1, -1),
            SCNVector3(-1, 1, 1), SCNVector3(-1, 1, -1), SCNVector3(-1, -1, 1), SCNVector3(-1, -1, -1),
            
            // Rectangle vertices
            SCNVector3(0, Float(invPhi), Float(phi)), SCNVector3(0, Float(invPhi), Float(-phi)),
            SCNVector3(0, Float(-invPhi), Float(phi)), SCNVector3(0, Float(-invPhi), Float(-phi)),
            
            SCNVector3(Float(invPhi), Float(phi), 0), SCNVector3(Float(invPhi), Float(-phi), 0),
            SCNVector3(Float(-invPhi), Float(phi), 0), SCNVector3(Float(-invPhi), Float(-phi), 0),
            
            SCNVector3(Float(phi), 0, Float(invPhi)), SCNVector3(Float(-phi), 0, Float(invPhi)),
            SCNVector3(Float(phi), 0, Float(-invPhi)), SCNVector3(Float(-phi), 0, Float(-invPhi))
        ]
        
        // Simplified indices for demonstration (full dodecahedron would have 60 triangles)
        let indices: [UInt16] = Array(0..<20).flatMap { i in
            [UInt16(i), UInt16((i + 1) % 20), UInt16((i + 2) % 20)]
        }
        
        return createCustomGeometry(vertices: vertices, indices: indices, number: 5)
    }
    
    private func createMerkaba3D() -> SCNNode {
        let node = SCNNode()
        
        // Upper tetrahedron (masculine/fire)
        let upperTetra = createSingleTetrahedron(scale: 1.0)
        upperTetra.position = SCNVector3(0, 0.2, 0)
        
        // Lower tetrahedron (feminine/water) - inverted
        let lowerTetra = createSingleTetrahedron(scale: 1.0)
        lowerTetra.rotation = SCNVector4(1, 0, 0, Float.pi)
        lowerTetra.position = SCNVector3(0, -0.2, 0)
        
        // Different materials for upper and lower
        if let upperGeometry = upperTetra.geometry {
            let upperMaterial = SCNMaterial()
            upperMaterial.diffuse.contents = UIColor.red.withAlphaComponent(0.7)
            upperMaterial.emission.contents = UIColor.red.withAlphaComponent(0.3)
            upperGeometry.materials = [upperMaterial]
        }
        
        if let lowerGeometry = lowerTetra.geometry {
            let lowerMaterial = SCNMaterial()
            lowerMaterial.diffuse.contents = UIColor.blue.withAlphaComponent(0.7)
            lowerMaterial.emission.contents = UIColor.blue.withAlphaComponent(0.3)
            lowerGeometry.materials = [lowerMaterial]
        }
        
        node.addChildNode(upperTetra)
        node.addChildNode(lowerTetra)
        
        return node
    }
    
    private func createSeedOfLife3D() -> SCNNode {
        let node = SCNNode()
        
        // Central sphere
        let centralSphere = SCNSphere(radius: 0.5)
        let centralNode = SCNNode(geometry: centralSphere)
        
        // 6 surrounding spheres
        for i in 0..<6 {
            let angle = Double(i) * Double.pi / 3.0
            let x = cos(angle) * 0.8
            let z = sin(angle) * 0.8
            
            let sphere = SCNSphere(radius: 0.5)
            let sphereNode = SCNNode(geometry: sphere)
            sphereNode.position = SCNVector3(Float(x), 0, Float(z))
            
            // Semi-transparent material
            let material = SCNMaterial()
            material.diffuse.contents = getSacredColor(for: 7).withAlphaComponent(0.6)
            material.emission.contents = getSacredColor(for: 7).withAlphaComponent(0.3)
            sphere.materials = [material]
            
            node.addChildNode(sphereNode)
        }
        
        // Central sphere material
        let centralMaterial = SCNMaterial()
        centralMaterial.diffuse.contents = getSacredColor(for: 7)
        centralMaterial.emission.contents = getSacredColor(for: 7).withAlphaComponent(0.5)
        centralSphere.materials = [centralMaterial]
        
        node.addChildNode(centralNode)
        return node
    }
    
    private func createOctahedron() -> SCNNode {
        let vertices: [SCNVector3] = [
            SCNVector3(0, 1, 0),    // top
            SCNVector3(1, 0, 0),    // right
            SCNVector3(0, 0, 1),    // front
            SCNVector3(-1, 0, 0),   // left
            SCNVector3(0, 0, -1),   // back
            SCNVector3(0, -1, 0)    // bottom
        ]
        
        let indices: [UInt16] = [
            // Upper pyramid
            0, 1, 2,  0, 2, 3,  0, 3, 4,  0, 4, 1,
            // Lower pyramid
            5, 2, 1,  5, 3, 2,  5, 4, 3,  5, 1, 4
        ]
        
        return createCustomGeometry(vertices: vertices, indices: indices, number: 8)
    }
    
    private func createIcosahedron() -> SCNNode {
        // Golden ratio for perfect icosahedron
        let phi = (1.0 + sqrt(5.0)) / 2.0
        
        // 12 vertices of icosahedron
        let vertices: [SCNVector3] = [
            SCNVector3(0, 1, Float(phi)), SCNVector3(0, 1, Float(-phi)),
            SCNVector3(0, -1, Float(phi)), SCNVector3(0, -1, Float(-phi)),
            
            SCNVector3(1, Float(phi), 0), SCNVector3(1, Float(-phi), 0),
            SCNVector3(-1, Float(phi), 0), SCNVector3(-1, Float(-phi), 0),
            
            SCNVector3(Float(phi), 0, 1), SCNVector3(Float(-phi), 0, 1),
            SCNVector3(Float(phi), 0, -1), SCNVector3(Float(-phi), 0, -1)
        ]
        
        // Simplified indices (full icosahedron would have 60 triangles)
        let indices: [UInt16] = Array(0..<12).flatMap { i in
            [UInt16(i), UInt16((i + 1) % 12), UInt16((i + 2) % 12)]
        }
        
        return createCustomGeometry(vertices: vertices, indices: indices, number: 9)
    }
    
    // MARK: - Helper Methods
    
    private func createSingleTetrahedron(scale: Float) -> SCNNode {
        let vertices: [SCNVector3] = [
            SCNVector3(0, scale, 0),
            SCNVector3(-scale * 0.866, -scale * 0.5, scale * 0.5),
            SCNVector3(scale * 0.866, -scale * 0.5, scale * 0.5),
            SCNVector3(0, -scale * 0.5, -scale)
        ]
        
        let indices: [UInt16] = [0, 1, 2, 0, 2, 3, 0, 3, 1, 1, 3, 2]
        
        return createCustomGeometry(vertices: vertices, indices: indices, number: 3)
    }
    
    private func createCustomGeometry(vertices: [SCNVector3], indices: [UInt16], number: Int) -> SCNNode {
        // Create geometry sources
        let vertexSource = SCNGeometrySource(vertices: vertices)
        
        // Create geometry element
        let element = SCNGeometryElement(
            indices: indices,
            primitiveType: .triangles
        )
        
        // Create geometry
        let geometry = SCNGeometry(sources: [vertexSource], elements: [element])
        
        // Apply sacred material
        let material = SCNMaterial()
        material.diffuse.contents = getSacredColor(for: number)
        material.emission.contents = getSacredColor(for: number).withAlphaComponent(0.4)
        material.metalness.contents = 0.6
        material.roughness.contents = 0.3
        geometry.materials = [material]
        
        return SCNNode(geometry: geometry)
    }
    
    private func getSacredColor(for number: Int) -> UIColor {
        switch number {
        case 1: return UIColor.red
        case 2: return UIColor.orange
        case 3: return UIColor.yellow
        case 4: return UIColor.green
        case 5: return UIColor.blue
        case 6: return UIColor.indigo
        case 7: return UIColor.purple
        case 8: return UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0) // gold
        case 9: return UIColor.white
        default: return UIColor.white
        }
    }
    
    // MARK: - Lighting Setup
    
    private func setupSacredLighting(scene: SCNScene, number: Int) {
        // Ambient light
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 300
        ambientLight.color = UIColor.white.withAlphaComponent(0.3)
        let ambientNode = SCNNode()
        ambientNode.light = ambientLight
        scene.rootNode.addChildNode(ambientNode)
        
        // Key light
        let keyLight = SCNLight()
        keyLight.type = .directional
        keyLight.intensity = 800
        keyLight.color = getSacredColor(for: number)
        let keyLightNode = SCNNode()
        keyLightNode.light = keyLight
        keyLightNode.position = SCNVector3(2, 3, 3)
        keyLightNode.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(keyLightNode)
        
        // Fill light
        let fillLight = SCNLight()
        fillLight.type = .directional
        fillLight.intensity = 400
        fillLight.color = UIColor.white
        let fillLightNode = SCNNode()
        fillLightNode.light = fillLight
        fillLightNode.position = SCNVector3(-2, 1, 2)
        fillLightNode.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(fillLightNode)
    }
    
    private func setupCamera(scene: SCNScene) {
        let camera = SCNCamera()
        camera.fieldOfView = 60
        camera.zNear = 0.1
        camera.zFar = 100
        
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, 5)
        
        scene.rootNode.addChildNode(cameraNode)
    }
    
    // MARK: - Animations
    
    private func startSacredAnimations(node: SCNNode, speed: Double) {
        // Rotation animation
        let rotation = CABasicAnimation(keyPath: "rotation")
        rotation.fromValue = SCNVector4(0, 1, 0, 0)
        rotation.toValue = SCNVector4(0, 1, 0, Float.pi * 2)
        rotation.duration = 10.0 / speed
        rotation.repeatCount = .infinity
        node.addAnimation(rotation, forKey: "rotation")
        
        // Gentle floating animation
        let float = CABasicAnimation(keyPath: "position.y")
        float.fromValue = -0.2
        float.toValue = 0.2
        float.duration = 3.0 / speed
        float.repeatCount = .infinity
        float.autoreverses = true
        node.addAnimation(float, forKey: "float")
    }
    
    private func updateAnimationSpeed(node: SCNNode, speed: Double) {
        // Update rotation speed
        if let rotation = node.animation(forKey: "rotation") as? CABasicAnimation {
            rotation.duration = 10.0 / speed
        }
        
        // Update float speed
        if let float = node.animation(forKey: "float") as? CABasicAnimation {
            float.duration = 3.0 / speed
        }
    }
}

#Preview {
    SacredGeometry3DView(number: 6, animationSpeed: 1.0)
        .frame(width: 300, height: 300)
        .background(Color.black)
} 