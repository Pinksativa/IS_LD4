function pozymiai = pozymiai_skaiciams_atpazinti(pavadinimas, pvz_eiluciu_sk)
%%  pozymiai = pozymiai_raidems_atpazinti(pavadinimas, pvz_eiluciu_sk)
% Features = pozymiai_raidems_atpazinti(image_file_name, Number_of_symbols_lines)
% taikymo pavyzdys:
% pozymiai = pozymiai_raidems_atpazinti('test_data.png', 8); 
% example of function use:
% Feaures = pozymiai_raidems_atpazinti('test_data.png', 8);
%%
% Vaizdo su pavyzdþiais nuskaitymas | Read image with written symbols
V = imread(pavadinimas);
%figure(12), imshow(V)
%% Perform segmentation of the symbols and write into cell variable 
% RGB image is converted to grayscale
V_pustonis = rgb2gray(V);
% a threshold value is calculated for binary image conversion
slenkstis = graythresh(V_pustonis);
% a grayscale image is converte to binary image
V_dvejetainis = im2bw(V_pustonis,slenkstis);
% show the resulting image
%figure(1), imshow(V_dvejetainis)                                <- COMMENTED
% search for the contour of each object
V_konturais = edge(uint8(V_dvejetainis));
% show the resulting image
%figure(2),imshow(V_konturais)                                   <- COMMENTED                                 
% fill the contours
se = strel('square',7); % strukturinis elementas uzpildymui
V_uzpildyti = imdilate(V_konturais, se); 
% show the result
%figure(3),imshow(V_uzpildyti)                                    <- COMMENTED  
% fill the holes
V_vientisi= imfill(V_uzpildyti,'holes');
% show the result
% figure(4),imshow(V_vientisi) <- COMMENTED
% set labels to binary image objects
[O_suzymeti Skaicius] = bwlabel(V_vientisi);
% calculate features for each symbol
O_pozymiai = regionprops(O_suzymeti);
% find/read the bounding box of the symbol
O_ribos = [O_pozymiai.BoundingBox];
% change the sequence of values, describing the bounding box
O_ribos = reshape(O_ribos,[4 Skaicius]); % Skaicius - objektø skaièius
% reag the mass center coordinate
O_centras = [O_pozymiai.Centroid];
% group center coordinate values
O_centras = reshape(O_centras,[2 Skaicius]);
O_centras = O_centras';
% set the label/number for each object in the image
O_centras(:,3) = 1:Skaicius;
% arrange objects according to the column number
O_centras = sortrows(O_centras,2);
% sort accordign to the number of rows and number of symbols in the row
raidziu_sk = Skaicius/pvz_eiluciu_sk;
for k = 1:pvz_eiluciu_sk
    O_centras((k-1)*raidziu_sk+1:k*raidziu_sk,:) = ...
        sortrows(O_centras((k-1)*raidziu_sk+1:k*raidziu_sk,:),3);
end
% cut the symbol from initial image according to the bounding box estimated in binary image
for k = 1:Skaicius
    objektai{k} = imcrop(V_dvejetainis,O_ribos(:,O_centras(k,3)));
end
% show one of the symbol's image
% figure(5),                                                   <- COMMENTED
% for k = 1:Skaicius
%    subplot(pvz_eiluciu_sk,raidziu_sk,k), imshow(objektai{k})
% end
% image segments are cutt off
for k = 1:Skaicius % Skaicius = 88, jei yra 88 raides
    V_fragmentas = objektai{k};
    % estimate the size of each segment
    [aukstis, plotis] = size(V_fragmentas);
    
    % 1. eliminate white spaces
    % apskaiciuokime kiekvieno stulpelio sumà
    stulpeliu_sumos = sum(V_fragmentas,1);
    % naikiname tuos stulpelius, kur suma lygi auksciui
    V_fragmentas(:,stulpeliu_sumos == aukstis) = [];
    % perskaiciuojamas objekto dydis
    [aukstis, plotis] = size(V_fragmentas);
    % 2. Baltu eluciu naikinimas
    % apskaiciuokime kiekvienos eilutes suma
    eiluciu_sumos = sum(V_fragmentas,2);
    % naikiname tas eilutes, kur suma lygi plociui
    V_fragmentas(eiluciu_sumos == plotis,:) = [];
    objektai{k}=V_fragmentas;% irasome vietoj neapkarpyto
end
% Vieno is vaizdo fragmentu atvaizdavimas                       <- COMMENTED
% show the segment
% figure(6),
% for k = 1:Skaicius
%    subplot(pvz_eiluciu_sk,raidziu_sk,k), imshow(objektai{k})
% end
%%
%% Make all segments of the same size 70x50
for k=1:Skaicius
    V_fragmentas=objektai{k};
    V_fragmentas_7050=imresize(V_fragmentas,[70,50]);
    % divide each image into 10x10 size segments
    for m=1:7
        for n=1:5
            % calculate an average intensity for each 10x10 segment
            Vid_sviesumas_eilutese=sum(V_fragmentas_7050((m*10-9:m*10),(n*10-9:n*10)));
            Vid_sviesumas((m-1)*5+n)=sum(Vid_sviesumas_eilutese);
        end
    end
    % 10x10 dydzio dalyje maksimali sviesumo galima reiksme yra 100
    % normuokime sviesumo reiksmes intervale [0, 1]
    % perform normalization
    Vid_sviesumas = ((100-Vid_sviesumas)/100);
    % rezultata (poþmius) neuronu tinklui patogiau pateikti stulpeliu
    % transform features into column-vector
    Vid_sviesumas = Vid_sviesumas(:);
    % isaugome apskaièiuotus pozymius i bendra kintamaji
    % save all fratures into single variable
    pozymiai{k} = Vid_sviesumas;
end
