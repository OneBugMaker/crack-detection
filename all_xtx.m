function all_xtx
clear all;close all;clc;warning('off');

Tu.zhanshi = true;     %  挑一张图片检测，并展示每一步处理后的效果
% Tu.zhanshi = false;  %  快速连续检测多张图片，但是不会展示每一步的处理效果

%% ==========================================================
if Tu.zhanshi  
    % 单张图片检测   
    % [filename, pathname]=uigetfile({'*.jpg','*.png'}, 'File Selector（对话框左上方显示）');
    % Tu.I=imread([pathname '\' filename]);    
    Tu.I=imread('.\data\neg\478.jpg');
    figure;imshow( Tu.I );%title('原图');
    
    Tu.Irf=Arf(Tu);%边缘检测函数 
    numIrf=bwarea(Tu.Irf);%目标检测后的像素个数 
    if numIrf==0          %边缘检测不到可疑区域
        disp('初步检测，没有可疑边缘');
    else    %numIrf>0
        disp('初步检测，存在可疑边缘');
    end   
else  % Tu.zhanshi == false-------------------------------------------
    read_path =  ['.\data\neg\';        '.\data\pos\'];
    write_path = ['.\new_data2\neg\';    '.\new_data2\pos\'];
    filename='.jpg';
    start = 1;
    len = 500 ;             %需要判断的图片总数
    for path_xuhao = 1:2
        result = zeros(len-start+1,1);  %用于存放判断结果,1=有裂纹，0=无裂纹，默认没有裂纹
        for i = start : start+len-1
            xuhao=num2str(i); 
            fullname = [read_path(path_xuhao,:), xuhao , filename];
            disp(' ');
            disp(['正在检测',fullname ]);
            Tu.I=imread(fullname);
    %         figure;imshow( Tu.I );title(['原图: ',fullname(25:end)]);
            Tu.Irf=Arf(Tu); %边缘检测函数
    %         figure;imshow( Tu.Irf );title('目标检测结果');
            numIrf=bwarea(Tu.Irf); %目标检测结果中所有目标像素个数之和
            if numIrf==0  %边缘检测不到可疑连通域
                disp('目标检测，没有  可疑边缘');
            else    %numIrf>0
                disp('目标检测，存在  可疑边缘');
                imwrite(Tu.Irf, [write_path(path_xuhao,:), xuhao , '.png'])      
            end % 单张图片检测完
            
            result(i)= numIrf > 0 ;
        end %循环检测完
        syou=sum(result);            %有裂纹的图片数
        rate=syou/len               %有裂纹图片比率
    end  % neg和pos都检测完

end % if Tu.zhanshi  完

end %main函数完


%% ===============目标检测函数=============================== 
function Irf=Arf(Tu)
Tu.Id =  im2double(Tu.I);
B     =  ones(3,3);
J     =  rangefilt(Tu.Id,B);%计算局部最大差值
Ez    =  im2bw(J,0.07);%原图的二值化

Sdy4  =  bwareaopen(Ez,4,8);  
P     =  imdilate(Sdy4,B);
F     =  imerode(P,B);

Tc    =  imfill(im2double(F));      
Irf   =  bwareaopen(Tc,500,8) - bwareaopen(Tc,20000,8);  %做子函数
disp('边缘检测完成');
if Tu.zhanshi
%     figure;imshow( J );title('局部最大差值');
    figure;imshow( Ez );% title('二值化');
    figure;imshow( Sdy4 );% title('大于4的');
    figure;imshow( F );% title('膨胀和腐蚀');
    figure;imshow( Tc );% title('Tc');
    figure;imshow( Irf );% title('Irf');
    
    figure;
    subplot(221);imshow( edge(Tu.Id, 'Sobel') );title('sobel');
    subplot(222);imshow( edge(Tu.Id, 'canny', [0.1,0.2]) );title('canny');
    subplot(223);imshow( Ez );title('rangefilt');
    subplot(224);imshow( Tu.Id );title('original image');
    
    figure;
    subplot(231);imshow( Tu.Id );title('original image');
    subplot(232);imshow( Ez );title('rangefilt');
    subplot(233);imshow( Sdy4 );title('greater than 4');
    subplot(234);imshow( F );title('closing');
    subplot(235);imshow( Tc );title('fill');
    subplot(236);imshow( Irf );title('500-20k');
    
    figure;
    subplot(131);imshow( Tu.Id );
    subplot(132);imshow( Ez );
    subplot(133);imshow( Irf );
end % 画图完

end