close all
clear all
clc
%% read the image with hand-written characters
pavadinimas = 'apmokymui.jpg';
pozymiai_tinklo_mokymui = pozymiai_skaiciams_atpazinti(pavadinimas, 8);
%% Development of character recognizer
% take the features from cell-type variable and save into a matrix-type variable
P = cell2mat(pozymiai_tinklo_mokymui);
% create the matrices of correct answers for each line (number of matrices = number of symbol lines)
T = [eye(10), eye(10), eye(10), eye(10), eye(10), eye(10), eye(10), eye(10)]; 
% create an RBF network for classification with 13 neurons, and sigma = 1
%tinklas = newrb(P,T,0,1,13);
tinklas = feedforwardnet(13);
tinklas = train(tinklas,P,T);

%% Tinklo patikra | Test of the network (recognizer)
% estimate output of the network for unknown symbols (row, that were not used during training)
P2 = P(:,11:20);
Y2 = sim(tinklas, P2);
% find which neural network output gives maximum value
[a2, b2] = max(Y2);
%% Visualize result
% calculate the total number of symbols in the row
raidziu_sk = size(P2,2);
% we will save the result in variable 'atsakymas'
atsakymas = [];
for k = 1:raidziu_sk
    switch b2(k)
        case 1
            % the symbol here should be the same as written first symbol in your image
            atsakymas = [atsakymas, '0'];
        case 2
            atsakymas = [atsakymas, '1'];
        case 3
            atsakymas = [atsakymas, '2'];
        case 4
            atsakymas = [atsakymas, '3'];
        case 5
            atsakymas = [atsakymas, '4'];
        case 6
            atsakymas = [atsakymas, '5'];
        case 7
            atsakymas = [atsakymas, '6'];
        case 8
            atsakymas = [atsakymas, '7'];
        case 9
            atsakymas = [atsakymas, '8'];
        case 10
            atsakymas = [atsakymas, '9'];
    end
end
% show the result in command window
disp(atsakymas)
% % figure(7), text(0.1,0.5,atsakymas,'FontSize',38)
%% Extract features of the test image
pavadinimas = 'isbandymui1.jpg';
pozymiai_patikrai = pozymiai_skaiciams_atpazinti(pavadinimas, 1);


%% Perform letter/symbol recognition
% features from cell-variable are stored to matrix-variable
P2 = cell2mat(pozymiai_patikrai);
% estimating neuran network output for newly estimated features
Y2 = sim(tinklas, P2);
% searching which output gives maximum value
[a2, b2] = max(Y2);
%% Rezultato atvaizdavimas | Visualization of result
% calculating number of symbols - number of columns
raidziu_sk = size(P2,2);
% rezultata saugosime kintamajame 'atsakymas'
atsakymas = [];
for k = 1:raidziu_sk
    switch b2(k)
        case 1
            atsakymas = [atsakymas, '0'];
        case 2
            atsakymas = [atsakymas, '1'];
        case 3
            atsakymas = [atsakymas, '2'];
        case 4
            atsakymas = [atsakymas, '3'];
        case 5
            atsakymas = [atsakymas, '4'];
        case 6
            atsakymas = [atsakymas, '5'];
        case 7
            atsakymas = [atsakymas, '6'];
        case 8
            atsakymas = [atsakymas, '7'];
        case 9
            atsakymas = [atsakymas, '8'];
        case 10
            atsakymas = [atsakymas, '9'];
    end
end
% pateikime rezultata komandiniame lange
% disp(atsakymas)
%figure(8), text(0.1,0.5,atsakymas,'FontSize',38), axis off
fprintf("\n Rezultatas %s\n",pavadinimas);
disp(atsakymas);
%% extract features for next/another test image
pavadinimas = 'isbandymui2.jpg';
pozymiai_patikrai = pozymiai_skaiciams_atpazinti(pavadinimas, 1);

%% Skaiciu atpazinimas
% pozymiai is celiu masyvo perkeliami i matrica
P2 = cell2mat(pozymiai_patikrai);
% skaiciuojamas tinklo atsakas nezinomiems pozymiams
Y2 = sim(tinklas, P2);
% ieskome, kuriame isejime gauta didziausia reiksme
[a2, b2] = max(Y2);
%% Rezultato atvaizdavimas
% apskaiciuosime raidziu skaiciu - pozymiu P2 stulpeliu skaiciu
raidziu_sk = size(P2,2);
% rezultata saugosime kintamajame 'atsakymas'
atsakymas = [];
for k = 1:raidziu_sk
    switch b2(k)
        case 1
            atsakymas = [atsakymas, '0'];
        case 2
            atsakymas = [atsakymas, '1'];
        case 3
            atsakymas = [atsakymas, '2'];
        case 4
            atsakymas = [atsakymas, '3'];
        case 5
            atsakymas = [atsakymas, '4'];
        case 6
            atsakymas = [atsakymas, '5'];
        case 7
            atsakymas = [atsakymas, '6'];
        case 8
            atsakymas = [atsakymas, '7'];
        case 9
            atsakymas = [atsakymas, '8'];
        case 10
            atsakymas = [atsakymas, '9'];
    end
end
% pateikime rezultata komandiniame lange
% disp(atsakymas)
%figure(9), text(0.1,0.5,atsakymas,'FontSize',38), axis off
fprintf("\n Rezultatas %s\n",pavadinimas);
disp(atsakymas);
