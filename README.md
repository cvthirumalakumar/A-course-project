# An-analysis-of-pitch-modifications-for-the-fusion-of-synthetic-and-natural-data-in-low-resource-AS
This is a course prioject done for Speech Signal Processing course at IIIT-Hyderabad during my MS in 2023.

### Goal of the project
Main idea of this project is to try pitch modification (i.e., making pitch constant in all voiced segnemts of the audio and the constat pitch is the average pitch of the audio) to conver all natural as well as synthetic data monotonous (to make natural and synthetic data closer to over come training data distibution differences when training asr with natural and synthetic data together in low resource setting or domain adaptation). Since prosody is the main difference between the natural and syhthetic which is composed of pitch, duration and energy mainly. In this project we attemped to change pitch to make entire training data resemble same distribution, where pitch modification block acts as front-end block while train and test. 

We compare WERs of natural and synthetic audios tested on 
* ASR trained on only Natural data
* ASR trained on Natutal+Synthetic data
* ASR trained on pitch modified version of Natural+Synthetic data

### Data
* We have used [Microsoft Telugu 40Hrs speech data](https://www.microsoft.com/en-us/download/details.aspx?id=105292) set as natural data for the experiments.
* Generated synthetic samples using [Indic-TTS](https://github.com/AI4Bharat/Indic-TTS) for sentences selected from Ai4Bharat text obtained from [Vakyansh repo](https://github.com/Open-Speech-EkStep/vakyansh-models). Number of sentences are equal to that of Microsoft data

