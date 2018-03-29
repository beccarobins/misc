function screen_capture(movie_name,recording_time)

%%Change pause(5) to the amount of time needed to pause before beginning
%%recording....recording will beging after the beep
pause(5)
beep

%%Change 'movie_name' to desired file name, ex. 'Trial_1'
movie_name1=strcat('Test','.avi')
mov = avifile(movie_name1,'compression', 'Cinepak');
count=0;
robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(t.getScreenSize());

%%Change recording_time to the desired recording time in seconds
%%Change sampling_rate to desired sampling rate (lower number=better quality)
 number_of_frames=round(recording_time/sampling_rate);
 display_time_of_frame=10;
 for i=1:number_of_frames
    name1=strcat('frame',num2str(i),'.png');
    %%Change 'frame' to the desired name of each individual frame, ex.
    %%'Trial_1_Frame'. Sequential numbers will be added to each frame.
    image = robo.createScreenCapture(rectangle);
    filehandle = java.io.File(name1);
    javax.imageio.ImageIO.write(image,'png',filehandle); 
end

for i=1:number_of_frames
name1=strcat('frame',num2str(i),'.png');
    %%Change 'frame' to the same name as previous 'frame' name change
    a=imread(name1);
    while count<display_time_of_frame
        count=count+1;
        F = im2frame(a);
        mov=addframe(mov,F);
    end
    count=0;
end
close all
mov=close(mov);
load gong;
wavplay(y,Fs) 

%%Wait for the gong!!