#include <iostream>
#include "Palindrome.cpp"

int main() {
    Palindrome<char> pal0 = Palindrome<char>();
    Palindrome<int> pal1 = Palindrome<int>(1);
    pal0 = pal0 + 'b';
    cout << "pal0: ";
    pal0.print();
    pal0 = pal0 + 'a';
    cout << "\n" << "pal0 after concat: ";
    pal0.print();
    cout << "\n" << "pal1 with 1 elem: ";
    pal1.print();
    pal1 = pal1 + 2;
    cout << "\n" << "pal 1 with 3 elems: ";
    pal1.print();
    cout << "\n" << "Checking ! operation: ";
    pal0 = !pal0;
    pal0.print();
    Palindrome<char> abcdcba = Palindrome<char>('d');
    abcdcba = abcdcba + 'c';
    abcdcba = abcdcba + 'b';
    abcdcba = abcdcba + 'a';
    cout << "\n" << "Checking / operation" << "\n" << "abcdcba: ";
    abcdcba.print();
    Palindrome<char> bdb = Palindrome<char>('d');
    bdb = bdb + 'b';
    cout << "\n" << "bdb: ";
    bdb.print();
    cout << "\n" << "abcdcba/bdb: ";
    abcdcba = abcdcba / bdb;
    abcdcba.print();
    Palindrome<char> acca = abcdcba;
    acca[0] = 'b';
    cout << "\n" << "New aca where the first a is changed to b: ";
    acca.print();
}