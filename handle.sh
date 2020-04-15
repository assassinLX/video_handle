# set -x
# for i in `ls *mp4`;do
#   f=$i
#   filename=${f%.*}
#   ffmpeg.exe -i $i -an -qscale 0 reduce/$filename.an.mp4;
#   ffmpeg.exe -i $i -vn reduce/$filename.wav
#   sox.exe reduce/$filename.wav reduce/$filename.clean.wav noisered samplenoise.prof 0.21
#   ffmpeg.exe -i reduce/$filename.clean.wav -i reduce/$filename.an.mp4 reduce/$filename.clean.mp4
#   done


set -x
for i in `ls *avi`;do
  f=$i
  filename=${f%.*}
  #-an代表不要音频，可能是audio no的缩写
  # -qscale 0 代表不压缩
  ffmpeg.exe -i $i -an -qscale 0 reduce/$filename.an.avi;
  #-vn代表不要视频画面，可能是video no的缩写
  ffmpeg.exe -i $i -vn reduce/$filename.wav

  #-ss代表起始时间，-t代表时间间隔，我们取一秒，最后的文件名都是输出文件名
  ffmpeg -i $i -vn -ss 00:00:07 -t 00:00:13 zang.wav

  #通过sox我们将噪音的特征提取出来，然后就需要这个.prof文件
  sox zang.wav -n noiseprof samplenoise.prof

  #注意后面的0.21，根据google到说明，是说值最好在0.2到2.3之间，为什么0.21是因为别人试验后最好的效果，可以自己做相应的调试，取值在0.2到0.3即可
  # sox 输出音频.wav 去噪的音频.wav noisered 噪音样本.prof 0.21
  sox.exe reduce/$filename.wav reduce/$filename.clean.wav noisered samplenoise.prof 0.21
  
  # 最后一步。合并视频跟去噪的音频
  # ffmpeg.exe -i 去噪的音频.wav -i 输出视频.mp4 最终视频文件.mp4
  ffmpeg.exe -i reduce/$filename.clean.wav -i reduce/$filename.an.avi  -c:v copy -c:a aac -strict experimental reduce/$filename.clean.avi
  done