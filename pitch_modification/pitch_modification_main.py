import os
import glob
import soundfile as sf
import pyworld
import numpy as np
import os
import matplotlib.pyplot as plt
from multiprocessing import Pool
from tqdm import tqdm

def world_decompose(wav, fs, frame_period=5.0):
    wav = wav.astype(np.float64)
    f0, timeaxis = pyworld.harvest(wav, fs, frame_period=frame_period, f0_floor=70.0, f0_ceil=800.0)
    sp = pyworld.cheaptrick(wav, f0, timeaxis, fs)
    ap = pyworld.d4c(wav, f0, timeaxis, fs)
    return f0, timeaxis, sp, ap

def world_speech_synthesis(f0, sp, ap, fs, frame_period=5.0):
    wav = pyworld.synthesize(f0, sp, ap, fs, frame_period)
    return wav
        
def modify(data):
    out_path = "/mnt/sd1/kumar/data/ssp_23_project_data/pitch_modification/modified_audios_all/natural/test"
    file_name = data['path'].split("/")[-1]
    wav, fs = sf.read(data['path'])
    wav = wav/max(abs(wav))
    pitch, time, sp, ap = world_decompose(wav, fs)
    
    mn_pitch = np.mean(pitch)
    indices = np.argwhere(pitch>0)
    
    pitch[indices] = mn_pitch
    
    # if data['index'] % 2 == 0:
    #     pitch[indices] = mn_pitch
    # else:
    #     pitch[indices] = 255
    #     #female = 255
    #     #male = 105
    
    pred_wav = world_speech_synthesis(pitch, sp, ap, fs)
    pred_wav = 0.95*pred_wav/(max(abs(pred_wav)))

    sf.write(out_path+"/"+file_name, pred_wav, fs)
    return 1

if __name__ == "__main__":
    
    inpath = "/mnt/sd2/Meenakshi/Dataset/microsoftspeechcorpusindianlanguages_o/te-in-Test/Audios"
    files = []
    for idx,file in enumerate(glob.glob(inpath+"/*")):
        files.append({'path':file,'index':idx})
    print("Generating samples")    
    with Pool(20) as p:
        text_new = list(tqdm(p.imap_unordered(modify, files), total=len(files)))
    p.close()
    p.join()
    print("Completed")