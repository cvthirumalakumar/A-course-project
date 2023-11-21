## Reference - https://github.com/gokulkarthik/text2speech

#### 1. Setup TTS
* Clone the github repo - https://github.com/gokulkarthik/text2speech
* Create environment
  sudo apt-get install libsndfile1-dev
  conda create -n tts-env
  conda activate tts-env
* Install PyTorch
  pip3 install -U torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
* Install requirements of TTS
  cd TTS
  pip3 install -e .[all]
  cd ..
  [or]
  cp TTS/TTS/bin/synthesize.py to the local TTS installation # added multiple output support for TTS.bin.synthesis
  pip3 install -r requirements.txt

#### 2. Model Checkpoint
Download the preferred language [TTS model checkpoints](https://github.com/AI4Bharat/Indic-TTS/releases/tag/v1-checkpoints-release) in your local directory and update the 'model_path' accordingly in runAllFiles.py

#### 3. Changes in runAllFiles.py
Update transcript_file, gender, out_path as per your usage.

#### 4. Execute
python3 runAllFiles.py




