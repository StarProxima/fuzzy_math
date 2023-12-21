import numpy as np

# Гиперпараметры
learning_rate = 0.01
n_hidden = 10
epochs = 1000000

# Инициализация весов
np.random.seed(42)
weights_input_hidden = np.random.randn(4, n_hidden)
weights_hidden_output = np.random.randn(n_hidden, 1)

# Функции активации и их производные
def sigmoid(x):
    return 1 / (1 + np.exp(-x))

def sigmoid_derivative(x):
    return x * (1 - x)

# Функция потерь и ее производная
def mse_loss(y_true, y_pred):
    return ((y_true - y_pred) ** 2).mean()

def mse_loss_derivative(y_true, y_pred):
    return 2 * (y_pred - y_true) / y_true.size

# Генерация обучающих данных
def generate_data():
    x1 = np.random.uniform(2, 4, 100)
    x2 = np.random.uniform(4, 6, 100)
    x3 = np.random.uniform(6, 8, 100)
    x4 = np.random.uniform(8, 10, 100)
    X = np.array([x1, x2, x3, x4]).T
    Y = (x1 + x2) * (x3 + x4)
    Y = Y.reshape(-1, 1)
    return X, Y

X, Y = generate_data()

# Обучение
for epoch in range(epochs):
    # Прямое распространение
    hidden_layer_input = np.dot(X, weights_input_hidden)
    hidden_layer_output = sigmoid(hidden_layer_input)
    output_layer_input = np.dot(hidden_layer_output, weights_hidden_output)
    y_pred = output_layer_input

    # Вычисление ошибки
    loss = mse_loss(Y, y_pred)

    # Обратное распространение
    d_loss_dy_pred = mse_loss_derivative(Y, y_pred)
    d_y_pred_d_h = weights_hidden_output
    d_loss_d_h = d_loss_dy_pred * d_y_pred_d_h.T
    d_h_d_h_input = sigmoid_derivative(hidden_layer_output)

    # Градиенты для весов
    d_loss_w_h_o = np.dot(hidden_layer_output.T, d_loss_dy_pred)
    d_loss_w_i_h = np.dot(X.T, d_loss_d_h * d_h_d_h_input)

    # Обновление весов
    weights_hidden_output -= learning_rate * d_loss_w_h_o
    weights_input_hidden -= learning_rate * d_loss_w_i_h

    if epoch % 100 == 0:
        print(f'Epoch {epoch}, Loss: {loss}')

print("Обучение завершено")

# ... [продолжение предыдущего кода]

# Генерация тестовых данных
X_test, Y_test = generate_data()

# Оценка сети на тестовых данных
hidden_layer_input_test = np.dot(X_test, weights_input_hidden)
hidden_layer_output_test = sigmoid(hidden_layer_input_test)
output_layer_input_test = np.dot(hidden_layer_output_test, weights_hidden_output)
y_pred_test = output_layer_input_test

# Вычисление ошибки на тестовых данных
test_loss = mse_loss(Y_test, y_pred_test)
print(f"Тестовая ошибка: {test_loss}")

# Вывод нескольких примеров предсказаний
for i in range(5):
    print(f"Входные данные: {X_test[i]}, Истинное значение: {Y_test[i][0]}, Предсказание: {y_pred_test[i][0]}")
