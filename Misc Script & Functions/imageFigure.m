
[figA,~]= imread('IMG_0166.jpg');
[figB,~]= imread('IMG_0166.jpg'); 
[figC,~]= imread('Fig1c.png');
figC = imresize(figC,.5);
[figD,~]= imread('Fig1d.png');
figD = imresize(figD,.5);

subplot_tight(2,4,1,.05)
imshow(figA);
text(1,1,'a','fontsize',26,'fontweight','bold','color','w');
axis off

subplot_tight(2,2,2,.05)
imshow(figB);
text(1,1,'b','fontsize',26,'fontweight','bold','color','w');
axis off

subplot_tight(2,2,3,.05)
imshow(figC);
text(1,1,'c','fontsize',26,'fontweight','bold','color','w');
axis off

subplot_tight(2,2,4,.05)
imshow(figD);
text(1,1,'d','fontsize',26,'fontweight','bold','color','w');
axis off