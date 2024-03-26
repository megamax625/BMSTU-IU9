import numpy as np
from dataset import get_dataset
import matplotlib.pyplot as plt

def Linear(X):
    return X
def der_Linear(X):
    return np.ones_like(X)

def Sigmoid(X):
    return 1 / (1 + np.exp(-X))
def der_Sigmoid(X):
    return Sigmoid(X) * (1 - Sigmoid(X))

def Th(X):
    return (np.exp(2 * X) - 1) / (np.exp(2 * X) + 1)
def der_Th(X):
    return 4 / (np.exp(2 * X) + 1) ** 2

def ReLU(X):
    # return np.maximum(0.001 * X, X)
    return np.maximum(0, X)
def der_ReLU(X):
    # return np.where(X > 0, 1, 0.001)
    return np.where(X > 0, 1, 0)

def forward(inputs, W, B, activation_func):
    y = np.dot(inputs, W) + B
    z = activation_func(y)
    return z

def Error(Y_pred, Y):
    return (Y_pred - Y)  # dL/dY_pred

_, labels = get_dataset()

def test(x, expected, W, B, act):
    if np.array(x).ndim >= 2:
        x = np.array(x).reshape(20)
    z = forward(x, W, B, act)
    res = np.argmax(z)
    res_sym = labels[res]
    print(f"Got result {res_sym}, expected {expected}")

def train_SLP(X, Y, W, B, activation_func_name, epochs, lr=0.001, mode=0):
    if activation_func_name == 'Linear':
        activation_func = Linear
        der_func = der_Linear
    elif activation_func_name == 'Sigmoid':
        activation_func = Sigmoid
        der_func = der_Sigmoid
    elif activation_func_name == 'Th':
        activation_func = Th
        der_func = der_Th
    elif activation_func_name == 'ReLU':
        activation_func = ReLU
        der_func = der_ReLU

    loss = np.zeros_like(epochs, dtype=float)
    for i in range(len(epochs)):
        Y_pred = forward(X, W, B, activation_func=activation_func)
        error = Error(Y_pred, Y)
        loss[i] = np.mean(np.sum(error ** 2, axis=1))
        
        delta = error * der_func(Y_pred)
        delta_W = np.dot(np.transpose(X), delta)
        delta_B = np.sum(delta, axis=0)
    
        W -= lr * delta_W
        B -= lr * delta_B

    title_method_name = activation_func_name
    if activation_func_name == "ReLU" and mode == 0:
        title_method_name += " (bad initialization)"
    plt.title("Method used:" + title_method_name)
    plt.yscale('log')
    plt.ylabel('loss')
    plt.xlabel('epoch')
    plt.plot(epochs, loss)
    plt.show()

    if mode == 1:
        test0 = [[0, 1, 1, 0],
                 [1, 0, 0, 1],
                 [1, 0, 0, 1],
                 [1, 0, 0, 1],
                 [0, 1, 1, 0]]
        test(test0, 0, W, B, activation_func)

        test7 = [[1, 1, 1, 1],
                 [0, 0, 1, 0],
                 [0, 1, 1, 1],
                 [0, 0, 1, 0],
                 [0, 0, 1, 0]]
        test(test7, 7, W, B, activation_func)

        testG = [[1, 1, 1, 0],
                 [1, 0, 1, 1],
                 [1, 0, 0, 0],
                 [1, 0, 0, 0],
                 [1, 0, 0, 0]]
        test(testG, 'Г', W, B, activation_func)

        testD = [[0, 1, 1, 0],
                 [0, 1, 0, 1],
                 [0, 1, 0, 1],
                 [1, 1, 1, 1],
                 [1, 0, 0, 1]]
        test(testD, 'Д', W, B, activation_func)

        testE = [[1, 1, 1, 1],
                 [1, 0, 0, 0],
                 [1, 1, 1, 1],
                 [1, 0, 0, 0],
                 [1, 1, 1, 1]]
        test(testE, 'Е', W, B, activation_func)

        testT = [[1, 1, 1, 1],
                 [0, 1, 1, 0],
                 [0, 1, 1, 0],
                 [0, 1, 1, 0],
                 [0, 1, 1, 0]]
        test(testT, 'Т', W, B, activation_func)
        return W, B

def main():
    X, labels = get_dataset()
    X = np.array(X)
    X = X.reshape(X.shape[0], -1)  # flatten
    Input_num = len(X[0])
    Output_num = len(labels)
    print(f"Input num: {Input_num}, Output num: {Output_num}")
    Y = np.eye(Output_num)  # one-hot array of labels
    W = 0.01 * np.random.randn(Input_num, Output_num)
    B = np.zeros(Output_num)
    epochs = np.arange(1, 10000)
    for activation_function_name in ['Linear', 'Sigmoid', 'Th', 'ReLU']:
        train_SLP(np.copy(X), np.copy(Y), np.copy(W), np.copy(B), activation_function_name, epochs)
    # bad init for ReLU, try a different one:
    W = np.random.exponential(scale=0.01, size=(Input_num, Output_num))
    tr_W, tr_B = train_SLP(np.copy(X), np.copy(Y), np.copy(W), np.copy(B), 'ReLU', epochs, mode=1)
    print("Weights:")
    print(tr_W)
    print("Biases:")
    print(tr_B)

if __name__ == "__main__":
    main()