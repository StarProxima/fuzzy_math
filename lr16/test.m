% Гиперпараметры
learning_rate = 0.01;
n_hidden = 4;
epochs = 10000;


% Инициализация весов
rng(42)
weights_input_hidden = randn(4, n_hidden);
weights_hidden_output = randn(n_hidden, 1);

% Функция активации и ее производная
sigmoid = @(x) 1.0 ./ (1.0 + exp(-x));
sigmoid_derivative = @(x) x .* (1 - x);

% Функция потерь и ее производная
mse_loss = @(y_true, y_pred) mean((y_true - y_pred) .^ 2);
mse_loss_derivative = @(y_true, y_pred) 2 * (y_pred - y_true) / numel(y_true);


% Генерация обучающих данных
generate_data = @() deal(2 + 2*rand(100,1), 4 + 2*rand(100,1), 6 + 2*rand(100,1), 8 + 2*rand(100,1));
[x1, x2, x3, x4] = generate_data();
X = [x1 x2 x3 x4];
Y = (x1 + x2) .* (x3 + x4);

% Обучение
for epoch = 1:epochs
    % Прямое распространение
    hidden_layer_input = X * weights_input_hidden;
    hidden_layer_output = sigmoid(hidden_layer_input);
    output_layer_input = hidden_layer_output * weights_hidden_output;
    y_pred = output_layer_input;

    % Вычисление ошибки
    loss = mse_loss(Y, y_pred);

    % Обратное распространение
    d_loss_dy_pred = mse_loss_derivative(Y, y_pred);
    d_y_pred_d_h = weights_hidden_output';
    d_loss_d_h = d_loss_dy_pred * d_y_pred_d_h;
    d_h_d_h_input = sigmoid_derivative(hidden_layer_output);

    % Градиенты для весов
    d_loss_w_h_o = hidden_layer_output' * d_loss_dy_pred;
    d_loss_w_i_h = X' * (d_loss_d_h .* d_h_d_h_input);

    % Обновление весов
    weights_hidden_output = weights_hidden_output - learning_rate * d_loss_w_h_o;
    weights_input_hidden = weights_input_hidden - learning_rate * d_loss_w_i_h;

    if mod(epoch, 100) == 0
        disp(['Epoch ', num2str(epoch), ', Loss: ', num2str(loss)]);
    end
end

disp('Обучение завершено');

% Тестирование
[x1_test, x2_test, x3_test, x4_test] = generate_data();
X_test = [x1_test x2_test x3_test x4_test];
Y_test = (x1_test + x2_test) .* (x3_test + x4_test);

hidden_layer_input_test = X_test * weights_input_hidden;
hidden_layer_output_test = sigmoid(hidden_layer_input_test);
output_layer_input_test = hidden_layer_output_test * weights_hidden_output;
y_pred_test = output_layer_input_test;

test_loss = mse_loss(Y_test, y_pred_test);
disp(['Тестовая ошибка: ', num2str(test_loss)]);

for i = 1:5
    disp(['Входные данные: ', mat2str(X_test(i,:)), ', Истинное значение: ', num2str(Y_test(i)), ', Предсказание: ', num2str(y_pred_test(i))]);
end
