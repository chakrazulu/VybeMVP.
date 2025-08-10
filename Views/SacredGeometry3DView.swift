/*
 * ========================================
 * 🌌 SACRED GEOMETRY 3D VIEW - MYSTICAL POLYHEDRA RENDERER
 * ========================================
 *
 * CORE PURPOSE:
 * Advanced 3D sacred geometry renderer using SceneKit to display mathematically precise
 * mystical forms. Each number (1-9) maps to specific sacred polyhedra with procedural
 * generation, wireframe rendering, and cosmic animations.
 *
 * UI SPECIFICATIONS:
 * - Rendering: SceneKit-based 3D with UIViewRepresentable wrapper
 * - Viewport: Flexible sizing, typically 200×200pt in HomeView sacred geometry section
 * - Background: Transparent (UIColor.clear) for overlay on cosmic backgrounds
 * - Anti-aliasing: 4X multisampling for smooth wireframe edges
 * - Lighting: Omni light (intensity 300) + ambient light (intensity 100)
 *
 * SACRED GEOMETRY MAPPINGS:
 * 1=Unity Circle(Sphere r=1.0), 2=Vesica Piscis(Torus), 3=Tetrahedron(4 triangular faces)
 * 4=Cube(1.5×1.5×1.5), 5=Dodecahedron(Pentagonal prism), 6=Merkaba(Dual tetrahedra)
 * 7=Seed of Life(Torus r=1.2), 8=Octahedron(8 triangular faces), 9=Enneagram(9-pointed star)
 *
 * ANIMATION SYSTEM:
 * - Primary Rotation: Y-axis, 8.0s/animationSpeed duration, infinite repeat
 * - Floating Motion: ±0.1pt Y-axis, 3.0s duration, autoreverses
 * - Dynamic Speed: updateAnimationSpeed() adjusts rotation based on animationSpeed parameter
 * - Smooth Transitions: CABasicAnimation for fluid movement
 *
 * 3D RENDERING SPECIFICATIONS:
 * - Material Mode: .lines (wireframe) for transparency with background numbers
 * - Color System: Sacred colors (Red, Orange, Yellow, Green, Blue, Indigo, Purple, Gold, White)
 * - Emission: 50% alpha sacred color for inner glow effect
 * - Specular: 30% alpha sacred color for highlight reflections
 * - Geometry Precision: Custom vertex arrays for mathematical accuracy
 *
 * PERFORMANCE OPTIMIZATIONS:
 * - Segment Counts: Optimized for visual quality vs performance (Sphere=32, Torus=24×12)
 * - Node Recycling: updateUIView removes old geometry before adding new
 * - Animation Caching: Reuses animation keys for efficient updates
 * - Memory Management: Proper node cleanup prevents SceneKit memory leaks
 *
 * INTEGRATION POINTS:
 * - HomeView: Primary display in 350×350pt sacred geometry section
 * - RealmNumberView: Dynamic geometry updates based on realm number changes
 * - NumberMeaningView: Educational display of sacred form meanings
 * - Sacred color system: Unified with app-wide color theming
 *
 * MATHEMATICAL FOUNDATIONS:
 * - Tetrahedron: 4 vertices with precise triangular face calculations
 * - Octahedron: 6 vertices forming 8 triangular faces (dual of cube)
 * - Merkaba: Dual interlocking tetrahedra representing spiritual transformation
 * - Enneagram: 9-pointed star with outer/inner radius calculations
 * - Platonic Solids: Mathematically perfect forms with sacred proportions
 *
 * TECHNICAL NOTES:
 * - SceneKit integration requires UIViewRepresentable pattern
 * - Vertex arrays use SCNVector3 for 3D coordinate precision
 * - Face indices use UInt16 arrays for triangle primitive assembly
 * - Animation duration calculations prevent division by zero
 * - Wireframe mode ensures background visibility while maintaining form
 */

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
        sceneView.scene = createScene()
        sceneView.backgroundColor = UIColor.clear
        sceneView.allowsCameraControl = false
        sceneView.autoenablesDefaultLighting = true
        sceneView.antialiasingMode = .multisampling4X
        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update animation speed if needed
        updateAnimationSpeed(in: uiView.scene, speed: animationSpeed)

        // IMPORTANT: Update the geometry when the number changes
        if let scene = uiView.scene {
            // Remove old geometry node
            scene.rootNode.childNodes.forEach { node in
                if node.geometry != nil {
                    node.removeFromParentNode()
                }
            }

            // Add new geometry node for the current number
            let geometryNode = createSacredGeometryNode(for: number)
            scene.rootNode.addChildNode(geometryNode)
        }
    }

    /**
     * Creates the main 3D scene with sacred geometry based on the number
     */
    private func createScene() -> SCNScene {
        let scene = SCNScene()

        // Create the sacred geometry node
        let geometryNode = createSacredGeometryNode(for: number)
        scene.rootNode.addChildNode(geometryNode)

        // Add subtle lighting
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.light?.intensity = 300
        lightNode.light?.color = getSacredColor(for: number)
        lightNode.position = SCNVector3(0, 5, 5)
        scene.rootNode.addChildNode(lightNode)

        // Add ambient light
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 100
        ambientLight.light?.color = UIColor.white
        scene.rootNode.addChildNode(ambientLight)

        return scene
    }

    /**
     * Creates the appropriate sacred geometry node based on the number
     */
    private func createSacredGeometryNode(for number: Int) -> SCNNode {
        let node = SCNNode()

        switch number {
        case 1:
            node.geometry = createUnityCircle()
        case 2:
            node.geometry = createVesicaPiscis()
        case 3:
            node.geometry = createTetrahedron()
        case 4:
            node.geometry = createCube()
        case 5:
            node.geometry = createDodecahedron()
        case 6:
            node.geometry = createMerkaba()
        case 7:
            node.geometry = createSeedOfLife()
        case 8:
            node.geometry = createOctahedron()
        case 9:
            node.geometry = createEnneagram()
        default:
            node.geometry = createUnityCircle()
        }

        // Apply WIREFRAME material so numbers show through
        let material = SCNMaterial()
        material.fillMode = .lines  // THIS IS KEY - wireframe mode
        material.diffuse.contents = getSacredColor(for: number)
        material.emission.contents = getSacredColor(for: number).withAlphaComponent(0.5)
        // Make wireframes more visible with stronger colors
        material.specular.contents = getSacredColor(for: number).withAlphaComponent(0.3)
        node.geometry?.materials = [material]

        // Add rotation animation
        addRotationAnimation(to: node)

        return node
    }

    /**
     * Creates a Unity Circle (Sphere) - Number 1: The Monad
     */
    private func createUnityCircle() -> SCNGeometry {
        let sphere = SCNSphere(radius: 1.0)
        sphere.segmentCount = 32
        return sphere
    }

    /**
     * Creates Vesica Piscis - Number 2: Sacred Duality (Two intersecting spheres)
     */
    private func createVesicaPiscis() -> SCNGeometry {
        // Create a torus to represent the intersection/connection between two spheres
        let torus = SCNTorus(ringRadius: 0.8, pipeRadius: 0.3)
        torus.ringSegmentCount = 24
        torus.pipeSegmentCount = 12
        return torus
    }

    /**
     * Creates Tetrahedron - Number 3: Trinity
     */
    private func createTetrahedron() -> SCNGeometry {
        // Create a proper tetrahedron with 4 triangular faces
        let vertices: [SCNVector3] = [
            SCNVector3(0, 1, 0),      // Top vertex
            SCNVector3(-0.866, -0.5, 0.5),   // Bottom left
            SCNVector3(0.866, -0.5, 0.5),    // Bottom right
            SCNVector3(0, -0.5, -1)          // Bottom back
        ]

        let faceIndices: [UInt16] = [
            0, 1, 2,  // Front face
            0, 2, 3,  // Right face
            0, 3, 1,  // Left face
            1, 3, 2   // Bottom face
        ]

        let source = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: faceIndices, primitiveType: .triangles)

        return SCNGeometry(sources: [source], elements: [element])
    }

    /**
     * Creates Cube - Number 4: Foundation
     */
    private func createCube() -> SCNGeometry {
        let box = SCNBox(width: 1.5, height: 1.5, length: 1.5, chamferRadius: 0.0)
        return box
    }

    /**
     * Creates Pentagon - Number 5: Quintessence (Simplified)
     */
    private func createDodecahedron() -> SCNGeometry {
        // Simplified to a pentagonal prism for better visibility
        var vertices: [SCNVector3] = []
        let radius: Float = 1.0
        let height: Float = 0.6

        // Create pentagon vertices for top and bottom
        for i in 0..<5 {
            let angle = Float(i) * 2.0 * Float.pi / 5.0
            let x = radius * cos(angle)
            let z = radius * sin(angle)

            // Top pentagon
            vertices.append(SCNVector3(x, height, z))
            // Bottom pentagon
            vertices.append(SCNVector3(x, -height, z))
        }

        // Create faces connecting top and bottom pentagons
        var indices: [UInt16] = []

        // Connect top and bottom with triangles
        for i in 0..<5 {
            let topCurrent = UInt16(i * 2)
            let bottomCurrent = UInt16(i * 2 + 1)
            let topNext = UInt16(((i + 1) % 5) * 2)
            let bottomNext = UInt16(((i + 1) % 5) * 2 + 1)

            // Two triangles per side face
            indices.append(contentsOf: [topCurrent, bottomCurrent, topNext])
            indices.append(contentsOf: [topNext, bottomCurrent, bottomNext])
        }

        let source = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)

        return SCNGeometry(sources: [source], elements: [element])
    }

    /**
     * Creates Merkaba - Number 6: Star of David in 3D
     */
    private func createMerkaba() -> SCNGeometry {
        // Two interlocking tetrahedra - simplified for better visibility
        let vertices: [SCNVector3] = [
            // First tetrahedron (upward pointing)
            SCNVector3(0, 1.2, 0),           // Top
            SCNVector3(-1, -0.4, 1),         // Bottom left front
            SCNVector3(1, -0.4, 1),          // Bottom right front
            SCNVector3(0, -0.4, -1.4),       // Bottom back

            // Second tetrahedron (downward pointing)
            SCNVector3(0, -1.2, 0),          // Bottom
            SCNVector3(-1, 0.4, -1),         // Top left back
            SCNVector3(1, 0.4, -1),          // Top right back
            SCNVector3(0, 0.4, 1.4)          // Top front
        ]

        let faceIndices: [UInt16] = [
            // First tetrahedron
            0, 1, 2,  0, 2, 3,  0, 3, 1,  1, 3, 2,
            // Second tetrahedron
            4, 5, 6,  4, 6, 7,  4, 7, 5,  5, 7, 6
        ]

        let source = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: faceIndices, primitiveType: .triangles)

        return SCNGeometry(sources: [source], elements: [element])
    }

    /**
     * Creates Seed of Life - Number 7: Seven circles (Torus)
     */
    private func createSeedOfLife() -> SCNGeometry {
        let torus = SCNTorus(ringRadius: 1.2, pipeRadius: 0.25)
        torus.ringSegmentCount = 32
        torus.pipeSegmentCount = 16
        return torus
    }

    /**
     * Creates Octahedron - Number 8: Eight faces
     */
    private func createOctahedron() -> SCNGeometry {
        let vertices: [SCNVector3] = [
            SCNVector3(0, 1.2, 0),    // Top
            SCNVector3(1.2, 0, 0),    // Right
            SCNVector3(0, 0, 1.2),    // Front
            SCNVector3(-1.2, 0, 0),   // Left
            SCNVector3(0, 0, -1.2),   // Back
            SCNVector3(0, -1.2, 0)    // Bottom
        ]

        let faceIndices: [UInt16] = [
            // Top pyramid
            0, 1, 2,  0, 2, 3,  0, 3, 4,  0, 4, 1,
            // Bottom pyramid
            5, 2, 1,  5, 3, 2,  5, 4, 3,  5, 1, 4
        ]

        let source = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: faceIndices, primitiveType: .triangles)

        return SCNGeometry(sources: [source], elements: [element])
    }

    /**
     * Creates Enneagram - Number 9: Nine-pointed star (FIXED ROTATION)
     */
    private func createEnneagram() -> SCNGeometry {
        // Create a flatter 9-pointed star that rotates around Y-axis
        var vertices: [SCNVector3] = []
        let outerRadius: Float = 1.4
        let innerRadius: Float = 0.6

        // Create 9-pointed star in XZ plane (flat, rotates around Y-axis)
        for i in 0..<9 {
            let angle = Float(i) * 2.0 * Float.pi / 9.0

            // Outer point
            vertices.append(SCNVector3(
                outerRadius * cos(angle),
                0,  // Keep Y at 0 for flat rotation
                outerRadius * sin(angle)
            ))

            // Inner point
            let innerAngle = angle + Float.pi / 9.0
            vertices.append(SCNVector3(
                innerRadius * cos(innerAngle),
                0,  // Keep Y at 0 for flat rotation
                innerRadius * sin(innerAngle)
            ))
        }

        // Add center vertex
        vertices.append(SCNVector3(0, 0, 0))

        // Create triangular faces
        var faceIndices: [UInt16] = []
        for i in 0..<9 {
            let current = i * 2
            let next = ((i + 1) % 9) * 2
            let centerIndex = UInt16(vertices.count - 1)

            // Triangle from center to edge
            faceIndices.append(centerIndex)
            faceIndices.append(UInt16(current))
            faceIndices.append(UInt16(current + 1))

            faceIndices.append(centerIndex)
            faceIndices.append(UInt16(current + 1))
            faceIndices.append(UInt16(next))
        }

        let source = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: faceIndices, primitiveType: .triangles)

        return SCNGeometry(sources: [source], elements: [element])
    }

    /**
     * Returns the sacred color for each number
     */
    private func getSacredColor(for number: Int) -> UIColor {
        switch number {
        case 1: return UIColor.red
        case 2: return UIColor.orange
        case 3: return UIColor.yellow
        case 4: return UIColor.green
        case 5: return UIColor.blue
        case 6: return UIColor(red: 0.29, green: 0.0, blue: 0.51, alpha: 1.0) // indigo equivalent
        case 7: return UIColor.purple
        case 8: return UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) // gold
        case 9: return UIColor.white
        default: return UIColor.white
        }
    }

    /**
     * Adds smooth rotation animation to the geometry node
     */
    private func addRotationAnimation(to node: SCNNode) {
        let rotation = CABasicAnimation(keyPath: "rotation")
        rotation.toValue = NSValue(scnVector4: SCNVector4(0, 1, 0, Float.pi * 2))
        rotation.duration = 8.0 / max(animationSpeed, 0.1) // Prevent division by zero
        rotation.repeatCount = .infinity
        node.addAnimation(rotation, forKey: "rotation")

        // Add subtle floating animation
        let float = CABasicAnimation(keyPath: "position.y")
        float.fromValue = -0.1
        float.toValue = 0.1
        float.duration = 3.0
        float.autoreverses = true
        float.repeatCount = .infinity
        node.addAnimation(float, forKey: "float")
    }

    /**
     * Updates animation speed for all nodes in the scene
     */
    private func updateAnimationSpeed(in scene: SCNScene?, speed: Double) {
        guard let scene = scene else { return }

        scene.rootNode.enumerateChildNodes { node, _ in
            // Update rotation animation speed
            if node.animationKeys.contains("rotation") {
                let newRotation = CABasicAnimation(keyPath: "rotation")
                newRotation.toValue = NSValue(scnVector4: SCNVector4(0, 1, 0, Float.pi * 2))
                newRotation.duration = 8.0 / max(speed, 0.1)
                newRotation.repeatCount = .infinity
                node.addAnimation(newRotation, forKey: "rotation")
            }
        }
    }
}

#Preview {
    SacredGeometry3DView(number: 6, animationSpeed: 1.0)
        .frame(width: 200, height: 200)
}
