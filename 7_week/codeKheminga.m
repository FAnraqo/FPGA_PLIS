clc     % Очистка терминала перед работой программы
clear   % Освобождение памяти используемой переменными

% Инициализация переменных
K = 16;
ti = 1;

k = log2(K);
d0 = 2 * ti + 1;

n = k + d0;

% Инициализация порождающей матрицы
generating_matrix = zeros(k, n);

% Заполнение порождающей матрицы
for i = 1:k
    generating_matrix(i,i) = 1; % Заполнение единичной матрицы
    for j = k+1:n
        if (i + j ~= n + 1)
            generating_matrix(i, j) = 1; % Заполнение проверочных разрядов
        end
    end
end 

% Вывод в терминал порождающей матрицы
disp('Порождающая матрица:');
disp(generating_matrix);

% Инициализация проверочной матрицы
verification_matrix = zeros(d0, n);

% Заполнение проверочной матрицы
for i = 1:d0
    for j = 1:k
        verification_matrix(i, j) = generating_matrix(j,i+k); % Транспонирование подматрицы
    end
    for j = k+1:n
        if (j - k == i)
            verification_matrix(i, j) = 1; % Дописывание единичной матрицы
        end
    end
end

% Вывод в терминал проверочной матрицы
disp('Проверочная матрица:');
disp(verification_matrix);

% Ввод информационных бит
number_in = [1 0 1 0];

% Инициализация матрицы для кодирования
encoded_matrix = zeros(1,n);

% Запись информационных битов в матрицу
for i = 1:k
    encoded_matrix(1, i) = number_in(1,i);
end

% Кодирование основанное на проверочной матрице
for i = 1:3
    for j = 1:k
        if (verification_matrix(i,j) == 1)
            encoded_matrix(1, k+i) = xor(encoded_matrix(1, k+i), encoded_matrix(1,j));
        end
    end
end


% Вывод в терминал закодированной матрицы
disp('Закодированная матрица:');
disp(encoded_matrix);


% Инициализация матрицы для декодирования и матрицы для вывода результата
decoded_matrix = encoded_matrix;
matrix_out = zeros(1,k);

% Генерация рандого места для добавления одной ошибки
r = randi(n);
% Установка одной ошибки
decoded_matrix(1, r) = xor(decoded_matrix(1, r), 1);

% Вывод в терминал матрицы c ошибкой
disp('Матрица с добавленной ошибкой:');
disp(decoded_matrix);

% Инициализация матрицы для хранения синдромов
b = zeros(1, 3);

% Декодирование
for i = 1:d0
    for j = 1:n
        if (verification_matrix(i,j) == 1)
            b(1,i) = xor(b(1,i), decoded_matrix(1, j));
        end
    end 
end

% Вывод индекатора наличия ошибки
disp('Индекатор наличия ошибки:');
disp(b(1, 1) | b(1, 2) | b(1, 3));

% Исправление ошибки
for i = 1:k
    switch i
        case 1
            matrix_out(1, i) = xor(decoded_matrix(1,i), (b(1,1) & b(1,2) & ~b(1,3)));
        case 2
            matrix_out(1, i) = xor(decoded_matrix(1,i), (b(1,1) & ~b(1,2) & b(1,3)));
        case 3
            matrix_out(1, i) = xor(decoded_matrix(1,i), (~b(1,1) & b(1,2) & b(1,3)));
        case 4
            matrix_out(1, i) = xor(decoded_matrix(1,i), (b(1,1) & b(1,2) & b(1,3)));
    end
end

% Вывод выходной матрицы
disp('Информационыые биты после декодирования и исправления ошибки:');
disp(matrix_out);

