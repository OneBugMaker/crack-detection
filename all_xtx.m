function all_xtx
clear all;close all;clc;warning('off');

Tu.zhanshi = true;     %  ��һ��ͼƬ��⣬��չʾÿһ��������Ч��
% Tu.zhanshi = false;  %  ��������������ͼƬ�����ǲ���չʾÿһ���Ĵ���Ч��

%% ==========================================================
if Tu.zhanshi  
    % ����ͼƬ���   
    % [filename, pathname]=uigetfile({'*.jpg','*.png'}, 'File Selector���Ի������Ϸ���ʾ��');
    % Tu.I=imread([pathname '\' filename]);    
    Tu.I=imread('.\data\neg\478.jpg');
    figure;imshow( Tu.I );%title('ԭͼ');
    
    Tu.Irf=Arf(Tu);%��Ե��⺯�� 
    numIrf=bwarea(Tu.Irf);%Ŀ���������ظ��� 
    if numIrf==0          %��Ե��ⲻ����������
        disp('������⣬û�п��ɱ�Ե');
    else    %numIrf>0
        disp('������⣬���ڿ��ɱ�Ե');
    end   
else  % Tu.zhanshi == false-------------------------------------------
    read_path =  ['.\data\neg\';        '.\data\pos\'];
    write_path = ['.\new_data2\neg\';    '.\new_data2\pos\'];
    filename='.jpg';
    start = 1;
    len = 500 ;             %��Ҫ�жϵ�ͼƬ����
    for path_xuhao = 1:2
        result = zeros(len-start+1,1);  %���ڴ���жϽ��,1=�����ƣ�0=�����ƣ�Ĭ��û������
        for i = start : start+len-1
            xuhao=num2str(i); 
            fullname = [read_path(path_xuhao,:), xuhao , filename];
            disp(' ');
            disp(['���ڼ��',fullname ]);
            Tu.I=imread(fullname);
    %         figure;imshow( Tu.I );title(['ԭͼ: ',fullname(25:end)]);
            Tu.Irf=Arf(Tu); %��Ե��⺯��
    %         figure;imshow( Tu.Irf );title('Ŀ������');
            numIrf=bwarea(Tu.Irf); %Ŀ������������Ŀ�����ظ���֮��
            if numIrf==0  %��Ե��ⲻ��������ͨ��
                disp('Ŀ���⣬û��  ���ɱ�Ե');
            else    %numIrf>0
                disp('Ŀ���⣬����  ���ɱ�Ե');
                imwrite(Tu.Irf, [write_path(path_xuhao,:), xuhao , '.png'])      
            end % ����ͼƬ�����
            
            result(i)= numIrf > 0 ;
        end %ѭ�������
        syou=sum(result);            %�����Ƶ�ͼƬ��
        rate=syou/len               %������ͼƬ����
    end  % neg��pos�������

end % if Tu.zhanshi  ��

end %main������


%% ===============Ŀ���⺯��=============================== 
function Irf=Arf(Tu)
Tu.Id =  im2double(Tu.I);
B     =  ones(3,3);
J     =  rangefilt(Tu.Id,B);%����ֲ�����ֵ
Ez    =  im2bw(J,0.07);%ԭͼ�Ķ�ֵ��

Sdy4  =  bwareaopen(Ez,4,8);  
P     =  imdilate(Sdy4,B);
F     =  imerode(P,B);

Tc    =  imfill(im2double(F));      
Irf   =  bwareaopen(Tc,500,8) - bwareaopen(Tc,20000,8);  %���Ӻ���
disp('��Ե������');
if Tu.zhanshi
%     figure;imshow( J );title('�ֲ�����ֵ');
    figure;imshow( Ez );% title('��ֵ��');
    figure;imshow( Sdy4 );% title('����4��');
    figure;imshow( F );% title('���ͺ͸�ʴ');
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
end % ��ͼ��

end