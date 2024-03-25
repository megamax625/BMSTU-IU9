#include "Palindrome.h"
#include "deque"
#include <iostream>
using namespace std;

template<class T>
Palindrome<T>::Palindrome() {
    deque<T> pal;
    palind = pal;
}

template<class T>
Palindrome<T>::Palindrome(T elem) {
    deque<T> pal;
    pal.push_back(elem);
    palind = pal;
}

template<class T>
Palindrome<T>& Palindrome<T>::operator+(const T& elem) {
    palind.push_back(elem);
    palind.push_front(elem);
    return *this;
}

template<class T>
Palindrome<T>& Palindrome<T>::operator!() {
    palind.pop_back();
    palind.pop_front();
    return *this;
}

template<class T>
Palindrome<T>& Palindrome<T>::operator/(Palindrome<T>& pal) {
    T chars[1000];
    int size = 0;
    for (int i = 0; i < (pal.getSize() + 1) / 2; i++) {
        bool unique = true;
        for (int j = 0; j < size; j++) {
            if (pal[i] == chars[j]) unique = false;
        }
        if (unique) {
            chars[size] = pal[i];
            size++;
        }
    }
    for (int i = 0; i < (this->getSize() + 1) / 2; i++) {
        bool foundInOp = false;
        for (int j = 0; j < size; j++) {
            if (this->palind.at(i) == chars[j]) {
                if (((this->getSize() % 2) == 1) && (i == (this->getSize() - 1) / 2)) palind.erase(palind.begin() + i);
                else {
                    palind.erase(palind.begin() + i);
                    palind.erase(palind.begin() + this->getSize() - 2);
                }
            }
        }
    }
    return *this;
}

template<class T>
T &Palindrome<T>::operator[](int i) {
   return palind.at(i);
}

template<class T>
int Palindrome<T>::getSize() const {
    return palind.size();
}

template<class T>
void Palindrome<T>::print() {
    for (int i = 0; i < this->getSize(); i++) {
        std::cout << palind[i];
    }
}
