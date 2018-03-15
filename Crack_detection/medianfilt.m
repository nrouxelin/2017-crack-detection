function imOut = medianfilt(im, N)
% B = MEDIANFILT(A,N)		NxN smoothing spatial average filter.

[R,C] = size(im);

% pad near the edges with the symmetric extension
if mod(N,2)
   padTL = (N-1)/2;	% left and top
   padBR = (N-1)/2;	% bottom and right
else
   padTL = N/2 - 1;
   padBR = N/2;
end
offset = padTL;
paddedIm = zeros(R+N-1, C+N-1);
[padR,padC] = size(paddedIm);
% copy the main image
paddedImg((offset+1):(offset+R), (offset+1):(offset+C)) = im;
% now copy up into the symmetric extension - top, left, bottom, right
% what a pain - is there a simpler way?
paddedImg(1:padTL,(offset+1):(offset+C)) = flipud(im(1:padTL,:));
paddedImg((offset+1):(offset+R),1:padTL) = fliplr(im(:,1:padTL));
paddedImg((padR-padBR+1):padR,(offset+1):(offset+C)) = flipud(im((R-padBR+1):R,:));
paddedImg((offset+1):(offset+R),(padC-padBR+1):padC) = fliplr(im(:,(C-padBR+1):C));
% now the corners
paddedImg(1:padTL,1:padTL) = fliplr(flipud(im(1:padTL,1:padTL)));
paddedImg(1:padTL,(padC-padBR+1):padC) = fliplr(flipud(im(1:padTL,(C-padBR+1):C)));
paddedImg((padR-padBR+1):padR,(padC-padBR+1):padC) = fliplr(flipud(im((R-padBR+1):R,(C-padBR+1):C)));
paddedImg((padR-padBR+1):padR,1:padTL) = fliplr(flipud(im((R-padBR+1):R,1:padTL)));

%paddedImg	% debug

% Now apply the median filtering
imOut = zeros(padR,padC);
for i = (offset+1):(offset+R)
   for j = (offset+1):(offset+C)
      A = paddedImg((i-padTL):(i+padBR),(j-padTL):(j+padBR));
      imOut(i,j) = median(A(:));
   end
end

imOut = imOut((offset+1):(offset+R),(offset+1):(offset+C)); 