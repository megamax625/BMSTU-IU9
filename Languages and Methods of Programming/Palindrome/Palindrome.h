#ifndef PALINDROME_PALINDROME_H
#define PALINDROME_PALINDROME_H

#include <deque>
#include <ostream>

template<class T>
class Palindrome {
public:
    Palindrome();
    Palindrome(T elem);
    Palindrome<T>& operator+(const T& elem);
    Palindrome<T>& operator!();
    Palindrome<T>& operator/(Palindrome<T>& pal);
    T& operator[](int i);
    void print();
    std::deque<T> palind;
    int getSize() const;
};

#endif //PALINDROME_PALINDROME_H