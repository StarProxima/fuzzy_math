% Загрузка FIS
fis = readfis('PCSelection.fis');

% Тестовые данные
testData = [
    3.0, 16, 1200, 7;  % Сценарий 1
    2.0, 8, 800, 4;    % Сценарий 2
    4.5, 32, 1500, 9;  % Сценарий 3
    1.5, 4, 500, 2;    % Сценарий 4
    3.5, 16, 1000, 6;   % Сценарий 5
    2.5, 12, 450, 3
];

% Инициализация массива для результатов
results = zeros(size(testData, 1), 5);

% Вычисление результатов
for i = 1:size(testData, 1)
    output = evalfis(fis, testData(i, :));
    results(i, :) = [testData(i, :) output];
end

% Вывод результатов в виде таблицы
resultTable = array2table(results, 'VariableNames', {'ProcessorSpeed', 'RAM', 'Price', 'Graphics', 'BuyingConfidence'});
disp(resultTable);
