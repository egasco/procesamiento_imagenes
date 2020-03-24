max_frame=1453;
mkdir output/camino2
for i=1:max_frame
    fname = strcat('camino2/frame_',int2str(i),'.png');
    im = imread(fname);
    im=ecualizar_histograma(im);
     [ nim,A,mix,borders  ] = ld_hough( im, 'canny',0,50,130,pi/180,95,10,5);
    fname = strcat('output/camino2/frame_',int2str(i),'.png');
    imwrite(nim,fname);
end