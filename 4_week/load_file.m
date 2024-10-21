fileID = fopen('binary_data.bin', 'r');
binary_string = fscanf(fileID, '%s');
fclose(fileID);

binary_strings = regexp(binary_string, '.{1,8}', 'match');

decimal_array = zeros(1, length(binary_strings));

for i = 1:length(binary_strings)
    decimal_array(i) = bin2dec(binary_strings{i});
end

i = 1:length(M);

figure;
plot(i, M(1,i));
xlabel('time(s)');
ylabel('Amplitude');
grid on;
xlim([1 200]);
ylim([0 256]);
title("График элиментов массива после выгрузки из файла");