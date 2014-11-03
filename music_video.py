#!/usr/bin/env python

from moviepy.editor import AudioFileClip, ImageClip
from sys import argv

audio = AudioFileClip(argv[1])
clip = ImageClip(argv[2]).set_duration(audio.duration).set_audio(audio)
clip.write_videofile(argv[3])
