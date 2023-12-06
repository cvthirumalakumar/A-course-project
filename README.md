# An-analysis-of-pitch-modifications-for-the-fusion-of-synthetic-and-natural-data-in-low-resource-ASR
This is a course prioject done for Speech Signal Processing course at IIIT-Hyderabad in 2023.

### Goal of the project
Main idea of this project is to try pitch modification (i.e., making pitch constant in all voiced segnemts of the audio and the constat pitch is the average pitch of the audio) to conver all natural as well as synthetic data monotonous (to make natural and synthetic data closer to over come training data distibution differences when training asr with natural and synthetic data together in low resource setting or domain adaptation). Since prosody is the main difference between the natural and syhthetic which is composed of pitch, duration and energy mainly. In this project we attemped to change pitch to make entire training data resemble same distribution, where pitch modification block acts as front-end block while train and test. 

We compare WERs of natural and synthetic audios tested on 
* ASR trained on only Natural data
* ASR trained on Natutal+Synthetic data
* ASR trained on pitch modified version of Natural+Synthetic data

### Data
Experiments are conducted for Telugu language.
#### Natural data
We have used [Microsoft Telugu 40Hrs speech data](https://www.microsoft.com/en-us/download/details.aspx?id=105292) set as natural data for the experiments.
#### Synthetic data
* Generated synthetic samples using [Indic-TTS](https://github.com/AI4Bharat/Indic-TTS) for sentences selected from Ai4Bharat text obtained from [Vakyansh repo](https://github.com/Open-Speech-EkStep/vakyansh-models).
* Number of sentences are equal to that of Microsoft data.
* Selected text for male and female TTS and the code used for generating synthetic data are in `synthetic_data_generation` folder.

#### Pitch Modification
Code used for pitch modification is in `pitch_modification` folder.

### Experimental setup
* We have used Kaldi frame work to train ASR, training recipe is adapted from Librispeech recipe.
* Code used for ASR training and testing is in `kaldi_asr` folder.
* We have used [Unified Parser](https://www.iitm.ac.in/donlab/tts/unified.php) for generating pronunciation (Lexicon) and [KenLM](https://github.com/kpu/kenlm) for training Langauge Models.
* Follow `README.md` in corresponding folders to run the code.

More details in `report.pdf`
