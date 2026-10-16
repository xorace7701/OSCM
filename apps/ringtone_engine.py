#!/usr/bin/env python3
# ====================================================================
#               OSCM — Sovereign Audio Downsampling Engine             
#                 Telephony μ-Law Conversion Subsystem v1.0            
# ====================================================================
import os
import sys
import wave
import audioop

def convert_to_mulaw(input_wav_path, output_wav_path):
    """
    Downsamples any standard WAV audio asset down to exact Cisco hardware specs:
    8000Hz frequency sample rate, 1-channel strict mono, 8-bit mu-law encoding.
    """
    print(f"[OSCM AUDIO] Opening source asset: {input_wav_path}")
    
    if not os.path.exists(input_wav_path):
        print(f"❌ AUDIO FAULT: Source file missing at {input_wav_path}")
        return False

    try:
        # Open raw input wave file
        with wave.open(input_wav_path, 'rb') as src:
            src_params = src.getparams()
            src_frames = src.readframes(src_params.nframes)
            
            # Extract basic metrics
            src_rate = src_params.framerate
            src_width = src_params.sampwidth
            src_channels = src_params.nchannels
            
            print(f"   [+] Input Profile: {src_rate}Hz, {src_width*8}-bit, Channels: {src_channels}")

            # Phase 1: Convert Stereo to Mono if necessary
            if src_channels > 1:
                print("   [+] Merging multi-channel audio layout to strict mono...")
                src_frames = audioop.tomono(src_frames, src_width, 1, 1)
                src_channels = 1

            # Phase 2: Resample frequency rate to exactly 8000Hz
            if src_rate != 8000:
                print(f"   [+] Resampling audio clock frequency: {src_rate}Hz -> 8000Hz")
                state = None
                src_frames, state = audioop.ratecv(src_frames, src_width, 1, src_rate, 8000, state)
                src_rate = 8000

            # Phase 3: Transcode structural width down to 8-bit u-law format
            print("   [+] Transcoding raw PCM bits to telephony 8-bit μ-law blocks...")
            mulaw_frames = audioop.lin2ulaw(src_frames, src_width)
            
        # Write downsampled data structure out to the target peripheral directory
        with wave.open(output_wav_path, 'wb') as dst:
            dst.setnchannels(1)     # Strict Mono
            dst.setsampwidth(1)     # 8-bit width encoding
            dst.setframerate(8000)  # Telephony standard sample frequency
            dst.writeframes(mulaw_frames)

        print(f"✔️ AUDIO CONVERSION SUCCESS: Compiled asset saved to -> {output_wav_path}")
        return True

    except Exception as e:
        print(f"❌ CRITICAL AUDIO CODEC ERROR: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("OSCM Audio Tool Usage: python3 ringtone_engine.py [input.wav] [output.wav]")
        sys.exit(1)
        
    convert_to_mulaw(sys.argv[1], sys.argv[2])
