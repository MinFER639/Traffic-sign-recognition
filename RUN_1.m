load('rcnnZnakZPierwszenstwem.mat');
load('rcnnZnakStop.mat');
load('rcnnZnakUstapPierwszenstwa.mat');
load('rcnnZnakPrzejsciePieszych.mat');
load('rcnnZnakParking.mat');

% Read test image
testImage = imread(file);

bboxes=[];

[bboxes1,score1,label1] = detect(rcnnZnakZPierwszenstwem,testImage,'MiniBatchSize',128);
[bboxes2,score2,label2] = detect(rcnnZnakUstapPierwszenstwa,testImage,'MiniBatchSize',128);
[bboxes3,score3,label3] = detect(rcnnZnakStop,testImage,'MiniBatchSize',128);
[bboxes4,score4,label4] = detect(rcnnZnakPrzejsciePieszych,testImage,'MiniBatchSize',128);
[bboxes5,score5,label5] = detect(rcnnZnakParking,testImage,'MiniBatchSize',128);

[bboxes6,score6,label6] = detect(rcnnZnakZakazZatrzymywania,testImage,'MiniBatchSize',128);
while isempty(score1)==1 || isempty(score2)==1 || isempty(score3)==1 || isempty(score4)==1 || isempty(score5)==1 || isempty(score6)==1
    if isempty(score1)==1
        score1=0;
        bboxes1=[0,0,0,0];
        label1=0;
    elseif isempty(score2)==1
        score2=0;
        bboxes2=[0,0,0,0];
        label2=0;
    elseif isempty(score3)==1
        score3=0;
        bboxes3=[0,0,0,0];
        label3=categorical(0);
    elseif isempty(score4)==1
        score4=0;
        bboxes4=[0,0,0,0];
        label4=categorical(0);
    elseif isempty(score5)==1
        score5=0;
        bboxes5=[0,0,0,0];
        label5=categorical(0);
    elseif isempty(score6)==1
        score6=0;
        bboxes6=[0,0,0,0];
        label6=categorical(0);
    end
end

bboxes=[bboxes1;bboxes2;bboxes3;bboxes4;bboxes5;bboxes6];
score=[score1;score2;score3;score4;score5;score5];
label=[categorical(label1);categorical(label2);categorical(label3);categorical(label4);categorical(label5),categorical(label6)];

t1=table(bboxes,score);

[score, idx] = max(t1.score);

bbox = bboxes(idx, :);
annotation = sprintf('%s: (Pewność = %f)', label(idx), score);
annotation1 = sprintf('Wykryto znak: %s z pewnością równą %f', label(idx), score);

outputImage = insertObjectAnnotation(testImage, 'rectangle', bbox, annotation,'TextBoxOpacity',1,'FontSize',22,'LineWidth',3);

imshow(outputImage, 'Parent' , app.UIAxes_2);

app.Label.Text=annotation1;