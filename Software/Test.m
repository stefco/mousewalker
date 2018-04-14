videoObj = VideoReader('./Videos/Zsuzsa1/CIMG3976.MOV');
nFrames = videoObj.NumberOfFrames;
h = videoObj.Height;
w = videoObj.Width;
mov(1:nFrames) = struct('cdata', zeros(h, w, 3, 'uint8'), 'colormap', []);
for k = 1 : nFrames
  k
    mov(k).cdata = read(videoObj, k);
end

tic
for i=1:nFrames
    frame = mov(i).cdata;
    image(frame);
    drawnow;
end
secPerFrame = toc/nFrames