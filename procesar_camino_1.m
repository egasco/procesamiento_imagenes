max_frame=1431;
mkdir output/camino1
mkdir output/camino1_csv
umin=25;
umax=65;
pidiv=180;
uh=100;
delta_t=10;
delta_r=10;
fname=strcat('output/camino1_csv/out_',int2str(umin),'_',int2str(umax),'_',int2str(pidiv),'_',int2str(uh),'_',int2str(delta_t),'_',int2str(delta_r),'_',datestr(now,'yyyymmdd_HHMMSS'),'.csv');
fp=fopen(fname,'w+');
for i=1:max_frame
    fname = strcat('camino1/frame_',int2str(i),'.png');
    im = imread(fname);
    %im=ecualizar_histograma(im);
    [ nim,A,mix,borders,lines ] = ld_hough( im, 'canny',1,umin,umax,pi/pidiv,uh,delta_t,delta_r);
    for j = 1:size(lines,1)
        fprintf(fp,'%d %f %f %d\n',i,lines(j,1),lines(j,2),lines(j,3));
    end
    fname = strcat('output/camino1/frame_',int2str(i),'.png');
    imwrite(nim,fname);
end
fclose(fp);