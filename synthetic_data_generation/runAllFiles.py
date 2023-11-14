import subprocess
from multiprocessing import Pool
from tqdm import tqdm
import os

def synthesize_text(data_dict):
    try:
        out_path = "/mnt/sd1/kumar/data/ssp_23_project_data/TTS/generated_TTS_samples/female/"+data_dict['name']+".wav"
        command = [
            "python3",
            "-m",
            "TTS.bin.synthesize",
            "--text",
            data_dict['text'],
            "--model_path",
            "/mnt/sd1/kumar/data/ssp_23_project_data/TTS/te/fastpitch/best_model.pth",
            "--config_path",
            "/mnt/sd1/kumar/data/ssp_23_project_data/TTS/te/fastpitch/config.json",
            "--vocoder_path",
            "/mnt/sd1/kumar/data/ssp_23_project_data/TTS/te/hifigan/best_model.pth",
            "--vocoder_config_path",
            "/mnt/sd1/kumar/data/ssp_23_project_data/TTS/te/hifigan/config.json",
            "--out_path",
            out_path,
            "--speaker_idx",
            gender,
        ]

        subprocess.run(command)
        return 1
    except Exception as e:        
        return data_dict['name']

transcript_file = "/mnt/sd1/kumar/data/ssp_23_project_data/TTS/female_text"
gender = "female"
data = []
with open(transcript_file, 'r') as file:
    for line in file:
        line = line.strip()
        a, b = line.split(' ', 1)
        file_path = "/mnt/sd1/kumar/data/ssp_23_project_data/TTS/generated_TTS_samples/female/"+a+".wav"  # Replace with the path to your file
        if os.path.isfile(file_path):
            continue
        data.append({'name': a, 'text': b})

print("len(data):",len(data))
with Pool(20) as p:
    text_new = list(tqdm(p.imap_unordered(synthesize_text, data), total=len(data)))

p.close()
p.join()

output_file = "/mnt/sd1/kumar/data/ssp_23_project_data/TTS/output_female.txt"
with open(output_file, 'a') as file:
    for item in text_new:
        file.write(f"{item}\n")
