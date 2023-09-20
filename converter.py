import subprocess
import os
import tkinter as tk
from tkinter import filedialog
import concurrent.futures
import ffmpeg #if you have error have in the same folder ffmpeg

root = tk.Tk()
root.withdraw()

input_files = filedialog.askopenfilenames(title="Select input files")
output_dir = filedialog.askdirectory(title="Select output directory")

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

def convert_file(input_path):
    if input_path.endswith((".mp4", ".mp3", ".webm", ".mkv", ".avi", ".mov", ".flv", ".wav", ".aac", ".wma", ".ts", ".3gp")):
        filename = os.path.basename(input_path)
        output_path = os.path.join(output_dir, os.path.splitext(filename)[0] + ".mp3")
        subprocess.call(['ffmpeg','-hwaccel', 'cuvid', '-i', input_path, '-vn', '-ar', '44100', '-ac', '1', '-b:a', '64k', output_path])

with concurrent.futures.ThreadPoolExecutor() as executor:
    executor.map(convert_file, input_files)
