n_bit = 8;
N = 1000;
fs = 24000;

t = 0:1 / fs:(n_bit * N / fs);

A_1 = 1;
f_1 = 480;
y_1 = A_1 * sin(2 * pi * f_1 * t);

A_2 = 0.5;
f_2 = 1800;
y_2 = A_2 * sin(2 * pi * f_2 * t);

y = y_1 + y_2;

figure;
subplot(3, 1, 1);
plot(t, y_1);
xlabel('time(s)');
ylabel('Amplitude');
grid on;
xlim([0 0.02]);
title("График 1 сигнала");

subplot(3, 1, 2);
plot(t, y_2);
xlabel('time(s)');
ylabel('Amplitude');
grid on;
xlim([0 0.02]);
title("График 2 сигнала");

subplot(3, 1, 3);
plot(t, y);
xlabel('time(s)');
ylabel('Amplitude');
grid on;
xlim([0 0.02]);
title("График суммы двух сигналов");



M = zeros(1, length(y));
i = 1:length(M);

M(:) = y;

figure;
plot(i, M(1,i));
xlabel('time(s)');
ylabel('Amplitude');
grid on;
xlim([1 200]);
title("График элиментов массива");



M_max = max(abs(M));

M = round((M / M_max) * 128);

for j = i
    if (M(1, j) < 0)
        M(1, j) = 256 + M(1, j);
    end
end

figure;
plot(i, M(1,i));
xlabel('time(s)');
ylabel('Amplitude');
grid on;
xlim([1 200]);
ylim([0 256]);
title("График элиментов массива после преобразования в дополнительный код");



binary_strings = arrayfun(@(x) dec2bin(x, 8), M, 'UniformOutput', false);
binary_string = strcat(binary_strings{:});

fileID = fopen('binary_data.bin', 'w');
fprintf(fileID, '%s', binary_string);
fclose(fileID);