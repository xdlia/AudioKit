//
//  SynthViewController.swift
//  Synth UI Spike
//
//  Created by Matthew Fecher on 1/8/16.
//  Copyright © 2016 AudioKitizzle for Shizzle. All rights reserved.
//

import UIKit

// TODO: 
// * ADSR Sliders
// * Appropriate scales for Knobs
// * 1x images
// * Set sensible initial preset

class SynthViewController: UIViewController {
    
    // *********************************************************
    // MARK: - Instance Properties
    // *********************************************************
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var octavePositionLabel: UILabel!
    @IBOutlet weak var oscMixKnob: KnobMedium!
    @IBOutlet weak var osc1SemitonesKnob: KnobMedium!
    @IBOutlet weak var osc2SemitonesKnob: KnobMedium!
    @IBOutlet weak var osc2DetuneKnob: KnobMedium!
    @IBOutlet weak var lfoAmtKnob: KnobMedium!
    @IBOutlet weak var lfoRateKnob: KnobMedium!
    @IBOutlet weak var crushAmtKnob: KnobMedium!
    @IBOutlet weak var delayTimeKnob: KnobMedium!
    @IBOutlet weak var delayMixKnob: KnobMedium!
    @IBOutlet weak var reverbAmtKnob: KnobMedium!
    @IBOutlet weak var reverbMixKnob: KnobMedium!
    @IBOutlet weak var cutoffKnob: KnobLarge!
    @IBOutlet weak var rezKnob: KnobSmall!
    @IBOutlet weak var subMixKnob: KnobSmall!
    @IBOutlet weak var fmMixKnob: KnobSmall!
    @IBOutlet weak var fmModKnob: KnobSmall!
    @IBOutlet weak var pwmKnob: KnobSmall!
    @IBOutlet weak var noiseMixKnob: KnobSmall!
    @IBOutlet weak var masterVolKnob: KnobSmall!
    
    enum ControlTag: Int {
        case Cutoff = 101
        case Rez = 102
        case Vco1Waveform = 103
        case Vco2Waveform = 104
        case Vco1Semitones = 105
        case Vco2Semitones = 106
        case Vco2Detune = 107
        case OscMix = 108
        case SubMix = 109
        case FmMix = 110
        case FmMod = 111
        case LfoWaveform = 112
        case Pwm = 113
        case NoiseMix = 114
        case LfoAmt = 115
        case LfoRate = 116
        case CrushAmt = 117
        case DelayTime = 118
        case DelayMix = 119
        case ReverbAmt = 120
        case ReverbMix = 121
        case MasterVol = 122
    }
    
    var keyboardOctavePosition: Int = 0
    
    // *********************************************************
    // MARK: - viewDidLoad
    // *********************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create Waveform Segment Views
        createWaveFormSegmentViews()
        
        // Set Delegates
        setDelegates()
        
        // Set Default Control Values
        setDefaultValues()
    }
    
    func setDelegates() {
        oscMixKnob.delegate = self
        cutoffKnob.delegate = self
        rezKnob.delegate = self
        osc1SemitonesKnob.delegate = self
        osc2SemitonesKnob.delegate = self
        osc2DetuneKnob.delegate = self
        lfoAmtKnob.delegate = self
        lfoRateKnob.delegate = self
        crushAmtKnob.delegate = self
        delayTimeKnob.delegate = self
        delayMixKnob.delegate = self
        reverbAmtKnob.delegate = self
        reverbMixKnob.delegate = self
        subMixKnob.delegate = self
        fmMixKnob.delegate = self
        fmModKnob.delegate = self
        pwmKnob.delegate = self
        noiseMixKnob.delegate = self
        masterVolKnob.delegate = self
    }

    // *********************************************************
    // MARK: - Defaults/Presets
    // *********************************************************
    
    func setDefaultValues() {
        
         statusLabel.text = "Welcome to Swift Synth"
        
        // Initial Values
        cutoffKnob.knobValue = CGFloat(cutoffKnob.scaleForKnobValue(3000.0, rangeMin: 150.0, rangeMax: 24000.0))
        
        osc1SemitonesKnob.knobValue = CGFloat(cutoffKnob.scaleForKnobValue(20, rangeMin: -12, rangeMax: 24))
        
        print(osc1SemitonesKnob.knobValue)
        
        // Set Osc Waveform Defaults
    }


    //*****************************************************************
    // MARK: - UI Helpers
    //*****************************************************************
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func createWaveFormSegmentViews() {
        setupOscSegmentView(8, y: 75.0, width: 195, height: 46.0, tag: ControlTag.Vco1Waveform.rawValue, type: 0)
        setupOscSegmentView(212, y: 75.0, width: 226, height: 46.0, tag: ControlTag.Vco2Waveform.rawValue, type: 0)
        setupOscSegmentView(10, y: 377, width: 255, height: 46.0, tag: ControlTag.LfoWaveform.rawValue, type: 1)
    }
    
    func setupOscSegmentView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, tag: Int, type: Int) {
        let segmentFrame = CGRect(x: x, y: y, width: width, height: height)
        let segmentView = SMSegmentView(frame: segmentFrame)
        
        if type == 0 {
            segmentView.createOscSegmentView(tag)
        } else {
            segmentView.createLfoSegmentView(tag)
        }
        
        segmentView.delegate = self
        
        // Set segment with index 0 as selected by default
        segmentView.selectSegmentAtIndex(0)
        self.view.addSubview(segmentView)
    }

    //*****************************************************************
    // MARK: - IBActions
    //*****************************************************************
    
    @IBAction func vco1Toggled(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            statusLabel.text = "VCO 1 Off"
        } else {
            sender.selected = true
            statusLabel.text = "VCO 1 On"
        }
    }
    
    @IBAction func vco2Toggled(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            statusLabel.text = "VCO 2 Off"
        } else {
            sender.selected = true
            statusLabel.text = "VCO 2 On"
        }
    }

    @IBAction func crusherToggled(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            statusLabel.text = "Bitcrush Off"
        } else {
            sender.selected = true
            statusLabel.text = "Bitcrush On"
        }
    }
    
    @IBAction func filterToggled(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            statusLabel.text = "Filter Off"
        } else {
            sender.selected = true
            statusLabel.text = "Filter On"
        }
    }
    
    @IBAction func delayToggled(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            statusLabel.text = "Delay Off"
        } else {
            sender.selected = true
            statusLabel.text = "Delay On"
        }
    }
    
    @IBAction func ReverbToggled(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            statusLabel.text = "Reverb Off"
        } else {
            sender.selected = true
            statusLabel.text = "Reverb On"
        }
    }
    
    @IBAction func StereoFattenToggled(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            statusLabel.text = "Stereo Fatten On"
        } else {
            sender.selected = true
            statusLabel.text = "Stereo Fatten Off"
        }
    }
    
    // Keyboard
    @IBAction func octaveDownPressed(sender: UIButton) {
        guard keyboardOctavePosition > -3 else { return }
        statusLabel.text = "Keyboard Octave Down"
        keyboardOctavePosition += -1
        octavePositionLabel.text = String(keyboardOctavePosition)
    }
    
    @IBAction func octaveUpPressed(sender: UIButton) {
        guard keyboardOctavePosition < 3 else { return }
        statusLabel.text = "Keyboard Octave Up"
        keyboardOctavePosition += 1
        octavePositionLabel.text = String(keyboardOctavePosition)
    }
    
    @IBAction func holdModeToggled(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            statusLabel.text = "Hold Mode Off"
        } else {
            sender.selected = true
            statusLabel.text = "Hold Mode On"
        }
    }
    
    @IBAction func monoModeToggled(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            statusLabel.text = "Mono Mode Off"
        } else {
            sender.selected = true
            statusLabel.text = "Mono Mode On"
        }
    }
    
    
    // Utility
    @IBAction func audioKitHomepage(sender: UIButton) {
        
    }
    
    @IBAction func buildThisSynth(sender: RoundedButton) {
        
    }
    
    //*****************************************************************
    // MARK: - 🎹 Key presses
    //*****************************************************************
    
    // Keys
    @IBAction func keyPressed(sender: UIButton) {
        statusLabel.text = "Key Pressed: \(sender.tag)"
        
    }
    
    @IBAction func keyReleased(sender: UIButton) {
        statusLabel.text = "Key Released"
    }
    
}



//*****************************************************************
// MARK: - 🎛 Knob Delegates
//*****************************************************************

extension SynthViewController: KnobSmallDelegate, KnobMediumDelegate, KnobLargeDelegate {
    
    func updateKnobValue(value: Float, tag: Int) {
        
        switch (tag) {
            
        // VCOs
        case ControlTag.Vco1Semitones.rawValue:
            let scaledValue = Float.scaleRange(value, rangeMin: -24, rangeMax: 25)
            let intValue = Int(floorf(scaledValue))
            statusLabel.text = "Semitones: \(intValue)"
            
        case ControlTag.Vco2Semitones.rawValue:
            let scaledValue = Float.scaleRange(value, rangeMin: -24, rangeMax: 25)
            let intValue = Int(floorf(scaledValue))
            statusLabel.text = "Semitones: \(intValue)"
            
        case ControlTag.Vco2Detune.rawValue:
            statusLabel.text = "Detune: \(value.decimalFormattedString)"
            
        case ControlTag.OscMix.rawValue:
            statusLabel.text = "OscMix: \(value.decimalFormattedString)"
            
        case ControlTag.Pwm.rawValue:
            statusLabel.text = "Pulse Width: \(value.decimalFormattedString)"
            
        // Additional Oscillators
        case ControlTag.SubMix.rawValue:
            statusLabel.text = "Sub Osc: \(value.decimalFormattedString)"
            
        case ControlTag.FmMix.rawValue:
            statusLabel.text = "FM Amt: \(value.decimalFormattedString)"
            
        case ControlTag.FmMod.rawValue:
            statusLabel.text = "FM Mod: \(value.decimalFormattedString)"
        
        case ControlTag.NoiseMix.rawValue:
            statusLabel.text = "Noise Amt: \(value.decimalFormattedString)"
            
        // LFO
        case ControlTag.LfoAmt.rawValue:
            statusLabel.text = "LFO Amp: \(value.decimalFormattedString)"
            
        case ControlTag.LfoRate.rawValue:
            statusLabel.text = "LFO Rate: \(value.decimalFormattedString)"
       
        // Filter
        case ControlTag.Cutoff.rawValue:
            
            // Logarithmic scale to frequency
            let scaledValue = Float.scaleRangeLog(value, rangeMin: 30, rangeMax: 7000)
            let cutOffFrequency = Float(scaledValue) * 4
            statusLabel.text = "Cutoff: \(cutOffFrequency.decimalFormattedString)"
            
        case ControlTag.Rez.rawValue:
            statusLabel.text = "Rez: \(value.decimalFormattedString)"
            
        // Crusher
        case ControlTag.CrushAmt.rawValue:
            statusLabel.text = "Bitcrush: \(value.decimalFormattedString)"
            
        // Delay
        case ControlTag.DelayTime.rawValue:
            statusLabel.text = "Delay Time: \(value.decimalFormattedString)"
        
        case ControlTag.DelayMix.rawValue:
            statusLabel.text = "Delay Mix: \(value.decimalFormattedString)"
        
        // Reverb
        case ControlTag.ReverbAmt.rawValue:
            statusLabel.text = "Reverb Amt: \(value.decimalFormattedString)"
        
        case ControlTag.ReverbMix.rawValue:
            statusLabel.text = "Reverb Mix: \(value.decimalFormattedString)"
            
        // Master
        case ControlTag.MasterVol.rawValue:
            statusLabel.text = "Master Vol: \(value.decimalFormattedString)"
            
        default:
            break
        }
    }
}

//*****************************************************************
// MARK: - SegmentView Delegate (waveform selector)
//*****************************************************************

extension SynthViewController: SMSegmentViewDelegate {
    
    // SMSegment Delegate
    func segmentView(segmentView: SMBasicSegmentView, didSelectSegmentAtIndex index: Int) {
        
        switch (segmentView.tag) {
        case ControlTag.Vco1Waveform.rawValue:
            statusLabel.text = "VCO1 Waveform Changed"
            
        case ControlTag.Vco2Waveform.rawValue:
            statusLabel.text = "VCO2 Waveform Changed"
            
        case ControlTag.LfoWaveform.rawValue:
            statusLabel.text = "LFO Waveform Changed"
            
        default:
            break
        }
    }
}
