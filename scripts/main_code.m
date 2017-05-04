clc
clear
close all

imageFile='lena.bmp';
img_gray=rgb2gray(imread(imageFile));
img_gray=imnoise(img_gray,'salt & pepper',0.02);
info=imfinfo(imageFile);
img_log_out_translated=zeros(info.Height,info.Width);
I1=zeros(info.Height,info.Width);

%% Noise Reduction
img_gray=uint8(Adaptive_Median_Filter(double(img_gray)));

%% Logarithmic Transformation
img_log_out=log2(1+double(img_gray));
min_y=min(min(img_log_out));
max_y=max(max(img_log_out));
if max_y<=2*min_y
    I=img_log_out;
else
    t=max_y-(2.*min_y);
    img_log_out_translated=img_log_out+t;            
    I=img_log_out_translated;
end
Original_Image=I;
I=padarray(I,[2 2],'replicate','both');
field='f';
T=struct(field,{});
I2=zeros(info.Height,info.Width);

%% GM Advanced8SD
for i=3:1:info.Height+2
    for j=3:1:info.Width+2
        value={[I(i-1,j-1)  I(i-1,j)    I(i-1,j+1);
                I(i,j-1)    I(i,j)      I(i,j+1);
                I(i+1,j-1)  I(i+1,j)    I(i+1,j+1)]};
        T(i,j)=struct(field,value);
        if max(max(T(i,j).f)) == min(min(T(i,j).f))           
                I1(i-1,j-1)=0.25*(I(i-1,j-2)+I(i-2,j-1)+I(i-1,j)+I(i,j-1));
                I1(i-1,j)=0.25*(I(i-1,j-1)+I(i-2,j)+I(i-1,j+1)+I(i,j));
                I1(i-1,j+1)=0.25*(I(i-1,j)+I(i-2,j+1)+I(i-1,j+2)+I(i,j+1));
                I1(i,j-1)=0.25*(I(i,j-2)+I(i-1,j-1)+I(i,j)+I(i+1,j-1));
                I1(i,j)=I(i,j);
                I1(i,j+1)=0.25*(I(i,j)+I(i-1,j+1)+I(i,j+2)+I(i+1,j+1));
                I1(i+1,j-1)=0.25*(I(i+1,j-2)+I(i,j-1)+I(i+1,j)+I(i+2,j-1));
                I1(i+1,j)=0.25*(I(i+1,j-1)+I(i,j)+I(i+1,j+1)+I(i+2,j));
                I1(i+1,j+1)=0.25*(I(i+1,j)+I(i,j+1)+I(i+1,j+2)+I(i+2,j+1));
            value_2={[I1(i-1,j-1) I1(i-1,j) I1(i-1,j+1);
                I1(i,j-1) I1(i,j) I1(i,j+1);
                I1(i+1,j-1) I1(i+1,j) I1(i+1,j+1)]};
            I2(i-2,j-2)=GMAdvanced8SD(cell2mat(value_2));
        else
            I2(i-2,j-2)=GMAdvanced8SD(cell2mat(value));
        end
    end
end
Predicted_Image=I2;
edge_image=Predicted_Image-Original_Image;
median_image=Adaptive_Median_Filter(edge_image);
for i=1:1:1
median_image=Adaptive_Median_Filter(median_image);
end

P=zeros(info.Height,info.Width);
N=P;

for i=1:1:info.Height
    for j=1:1:info.Width
        if(median_image(i,j)>=0)
            P(i,j)=median_image(i,j);
            N(i,j)=0;
        else
            N(i,j)=(-1)*median_image(i,j);
            P(i,j)=0;
        end
    end
end
 
%% Overlaying positive and negative images
overlayed_image=P+N;
 
%% Resizing
resized_edge_image=imresize(overlayed_image,2,'bicubic');
 
%% 2D Discrete Wavelet Transform
[dwt_A,dwt_H,dwt_V,dwt_D]=dwt2(resized_edge_image, 'haar');
combined_high_frequency_image=dwt_H+dwt_V+dwt_D;
imshow(combined_high_frequency_image)
