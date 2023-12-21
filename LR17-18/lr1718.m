% Генерация обучающих данных
x1 = linspace(-1, 1, 25);
x2 = linspace(-1, 1, 25);
[X1, X2] = meshgrid(x1, x2);
d = (3 - 2*X1.^2) + (1 - 2*X2).^2;
data = [X1(:), X2(:), d(:)];

% Сохранение обучающих данных в файл
save('training_data.dat', 'data', '-ascii');

% Загрузка обучающих данных
data = load('training_data.dat');

% Варианты типов функций принадлежности
membership_functions = ["gaussmf", "trimf", "trapmf"];

% Инициализация ячеек для хранения результатов
output_cell = cell(length(membership_functions), 1);
error_cell = cell(length(membership_functions), 1);

% Обучение и оценка адекватности для каждого типа функции принадлежности
for i = 1:length(membership_functions)
    options = anfisOptions('Epoch', 10);
    opt.NumMembershipFunctions = [3 5 5];
    opt.InputMembershipFunctionType = repmat(membership_functions(i), 1, 3);
    fis_optimized = anfis(data, options, opt);

    % Оценка адекватности
    output = evalfis(fis_optimized, [X1(:), X2(:)]);
    error = (d(:) - output).^2;

    % Сохранение результатов в ячейки
    output_cell{i} = output;
    error_cell{i} = error;
end

results = table(repelem(X1(:), 1), ...
                      repelem(X2(:), 1), ...
                      repmat(d(:), 1, 1), ...
                      cell2mat(output_cell(1)), cell2mat(error_cell(1)), ...
                      cell2mat(output_cell(2)), cell2mat(error_cell(2)), ...
                      cell2mat(output_cell(3)), cell2mat(error_cell(3)), ...
                      'VariableNames', {'x1', 'x2', 'd', 'gaussmf_y', 'gaussmf_e',  'trimf_y', 'trimf_e', 'trapmf_y', 'trapmf_e'});

disp(results);
writetable(results, 'results.csv');
