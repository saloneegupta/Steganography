% Get rid of junk
clear all;
close all;
clc;

%@@ Image used as carrier for encoding message
carrier_image_filename = 'input/lena.jpg';

%@@ Message string to encode into carrier image
secret_msg_str = 'Test post; please ignore!';

carrier_original = rgb2gray(imread(carrier_image_filename));
secret_msg = str2bin(secret_msg_str);

% Encode, write, read, decode
frequency_coefficients = [7 6; 5 2];
[carrier_stego bits_written bits_unused] = steg_dct_encode(secret_msg, carrier_original, frequency_coefficients, 25);
imwrite(carrier_stego, 'stego_temp.jpg');
carrier_stego = imread('stego_temp.jpg');
[retrieved_msg] = steg_dct_decode(carrier_stego, frequency_coefficients);

% Verify and compare difference
msg_match = isequal(secret_msg(1:200), retrieved_msg(1:200));
difference = sum((carrier_original - carrier_stego) .^ 2);

% Display results
subplot(2,2,1);
imshow(carrier_original);
subplot(2,2,2);
imshow(carrier_stego);

fprintf('Difference: %d\n', sum(difference));

disp(['Encoded message: ', bin2str(secret_msg)]);
disp(['Decoded message: ', bin2str(retrieved_msg)]);