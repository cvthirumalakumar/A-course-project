Reference - https://github.com/gokulkarthik/text2speech

# 1. Create environment
sudo apt-get install libsndfile1-dev
conda create -n tts-env
conda activate tts-env

# 2. Setup PyTorch
pip3 install -U torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113

# 3. Setup TTS
git clone https://github.com/gokulkarthik/TTS 

cd TTS
pip3 install -e .[all]
cd ..
[or]
cp TTS/TTS/bin/synthesize.py to the local TTS installation # added multiple output support for TTS.bin.synthesis

# 4. Install other requirements
> pip3 install -r requirements.txt

# 5. Model Checkpoint
Download the preferred language [TTS model checkpoints](https://github.com/AI4Bharat/Indic-TTS/releases/tag/v1-checkpoints-release) in your local directory and update the 'model_path' accordingly in runAllFiles.py

# 6. Changes in runAllFiles.py
Update transcript_file, gender, out_path as per your usage.

# 7. Execute
python3 runAllFiles.py




