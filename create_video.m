function [ output_args ] = create_video( path,min_frame,max_frame )
%CREATE_VIDEO [ output_args ] = create_video( path,min_frame,max_frame )
%   Detailed explanation goes here

% Creating Video Writer Object
fout = strcat(path,'/output.avi');
writerObj = VideoWriter(fout);
% Using the 'Open` method to open the file
open(writerObj);



for i=min_frame:max_frame
    fname = strcat(path,'/frame_',int2str(i),'.png');
    im = imread(fname);
   % Frame includes image data

   % Adding the frame to the video object using the 'writeVideo' method
   writeVideo(writerObj,im);
end

% Closing the file and the object using the 'Close' method
close(writerObj);

end

