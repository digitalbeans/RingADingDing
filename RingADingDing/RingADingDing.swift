//
//  RingADingDing.swift
//  RingADingDing
//
//  Created by Dean Thibault on 5/25/19.
//  Copyright © 2019 Digital Beans. All rights reserved.
//

import UIKit

enum RingOrder: CGFloat {
	case trackBorder = 0
	case track = 1
	case ringBorder = 2
	case ring = 3
}

@IBDesignable
public class RingADingDing: UIView {

	/// The color to use for the track
	@IBInspectable public var trackStrokeColor: UIColor =
		.lightGray
	/// The ring color
	@IBInspectable public var strokeColor: UIColor = .red
	/// Fill color for the middle of the ring
	@IBInspectable public var fillColor: UIColor = .clear
	/// Width of the ring line
	@IBInspectable public var lineWidth: CGFloat = 20
	/// The style to use for the line end cap
	@IBInspectable public var lineCap: CAShapeLayerLineCap = .round
	// Duration of animation in seconds
	@IBInspectable public var duration: Double = 2
	@IBInspectable public var fillMode: CAMediaTimingFillMode = .forwards
	/// If true, animation is removed when complete
	@IBInspectable public var isRemovedOnCompletion: Bool = false
	/// The radious of the ring
	@IBInspectable public var radius: CGFloat = 100
	/// Start angle in radians for the the staring point of the ring, 0 is at 3 o'clock
	@IBInspectable public var startAngle: CGFloat = -CGFloat.pi / 2
	/// End angle in radians for the end point of the ring
	@IBInspectable public var endAngle: CGFloat =  2 * CGFloat.pi
	/// Direction of the animation. True = clockwise, False = counter-clockwise
	@IBInspectable public var clockwise: Bool = true
	/// If false, ring will be fully drawn without animation
	@IBInspectable public var isAnimated: Bool = true
	/// Ring border color
	@IBInspectable public var ringBorderColor: UIColor = .black
	/// Ring border width. Will decrease the ring stroke width. 0 Will result in no border.
	/// Needs to be less than 1/2 of the stroke width, or will cover the entire ring.
	@IBInspectable public var ringBorderWidth: CGFloat = 1
	/// Track border color
	@IBInspectable public var trackBorderColor: UIColor = .black
	/// Track border width. Will decrease the track stroke width. 0 Will result in no border.
	/// Needs to be less than 1/2 of the stroke width, or will cover the entire track.
	@IBInspectable public var trackBorderWidth: CGFloat = 0

	private var ringLayer: CAShapeLayer?
	private var ringBorderLayer: CAShapeLayer?
	private var trackBorderLayer: CAShapeLayer?
	private var trackLayer: CAShapeLayer?

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		layout()
	}

	public init(frame: CGRect,
		 trackStrokeColor: UIColor = .lightGray,
		 strokeColor: UIColor = .red,
		 fillColor: UIColor = .clear,
		 lineWidth: CGFloat = 20,
		 lineCap: CAShapeLayerLineCap = .round,
		 duration: Double = 1,
		 fillMode: CAMediaTimingFillMode = .forwards,
		 isRemovedOnCompletion: Bool = false,
		 radius: CGFloat = 100,
		 startAngle: CGFloat = -CGFloat.pi / 2,
		 endAngle: CGFloat =  2 * CGFloat.pi,
		 clockwise: Bool = true,
		 isAnimated: Bool = true) {
		super.init(frame: frame)
		
		self.trackStrokeColor = trackStrokeColor
		self.strokeColor = strokeColor
		self.fillColor = fillColor
		self.lineWidth = lineWidth
		self.lineCap = lineCap
		self.duration = duration
		self.fillMode = fillMode
		self.isRemovedOnCompletion = isRemovedOnCompletion
		self.radius = radius
		self.startAngle = startAngle
		self.endAngle = endAngle
		self.clockwise = clockwise
		
		layout()
	}
	private func removeLayers() {
		ringLayer?.removeFromSuperlayer()
		ringBorderLayer?.removeFromSuperlayer()
		trackLayer?.removeFromSuperlayer()
		trackBorderLayer?.removeFromSuperlayer()
	}
	
	private func layout() {
		removeLayers()
		
		let ringLayer = CAShapeLayer()
		self.ringLayer = ringLayer
		let ringBorderLayer = CAShapeLayer()
		self.ringBorderLayer = ringBorderLayer
		let trackBorderLayer = CAShapeLayer()
		self.trackBorderLayer = trackBorderLayer
		let trackLayer = CAShapeLayer()
		self.trackLayer = trackLayer
		
		let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle:endAngle, clockwise: clockwise)

		// set up the track border layer
		if trackBorderWidth > 0 {
			trackBorderLayer.zPosition = RingOrder.trackBorder.rawValue
			trackBorderLayer.path = trackPath.cgPath
			trackBorderLayer.strokeColor = trackBorderColor.cgColor
			trackBorderLayer.lineWidth = lineWidth
			trackBorderLayer.fillColor = fillColor.cgColor
			trackBorderLayer.lineCap = lineCap
			layer.addSublayer(trackBorderLayer)
		}

		// set up the track layer
		trackLayer.zPosition = RingOrder.track.rawValue
		trackLayer.path = trackPath.cgPath
		trackLayer.strokeColor = trackStrokeColor.cgColor
		trackLayer.lineWidth = trackBorderWidth > 0 ? lineWidth - (2 * trackBorderWidth) : lineWidth
		trackLayer.fillColor = fillColor.cgColor
		trackLayer.lineCap = lineCap
		layer.addSublayer(trackLayer)
		
		// setup ring border
		let ringPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle:endAngle, clockwise: clockwise)
		
		if ringBorderWidth > 0 {
			ringBorderLayer.zPosition = RingOrder.ringBorder.rawValue
			ringBorderLayer.path = ringPath.cgPath
			ringBorderLayer.strokeColor = ringBorderColor.cgColor
			ringBorderLayer.lineWidth = lineWidth
			ringBorderLayer.fillColor = fillColor.cgColor
			ringBorderLayer.lineCap = lineCap
			ringBorderLayer.strokeEnd = isAnimated ? 0 : 1
			layer.addSublayer(ringBorderLayer)
		}

		// setup the ring layer
		ringLayer.zPosition = RingOrder.ring.rawValue
		ringLayer.path = ringPath.cgPath
		ringLayer.strokeColor = strokeColor.cgColor
		ringLayer.lineWidth = ringBorderWidth > 0 ? lineWidth - (2 * ringBorderWidth) : lineWidth
		ringLayer.fillColor = fillColor.cgColor
		ringLayer.lineCap = lineCap
		ringLayer.strokeEnd = isAnimated ? 0 : 1
		layer.addSublayer(ringLayer)
		

	}
	
	public func addTrackBorder(trackBorderWidth: CGFloat, trackBorderColor: UIColor) {
		self.trackBorderWidth = trackBorderWidth
		self.trackBorderColor = trackBorderColor
	}
	
	public func addRingBorder(ringBorderWidth: CGFloat, ringBorderColor: UIColor) {
		self.ringBorderWidth = ringBorderWidth
		self.ringBorderColor = ringBorderColor
	}
	
	public func animate() {
		if isAnimated {
			let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
			basicAnimation.toValue = 1
			basicAnimation.duration = duration
			basicAnimation.fillMode = fillMode
			basicAnimation.isRemovedOnCompletion = isRemovedOnCompletion
			if ringBorderWidth > 0 {
				ringBorderLayer?.add(basicAnimation, forKey: "ringBorderAnimation")
			}
			ringLayer?.add(basicAnimation, forKey: "ringAnimation")
		}
	}
}
