#include "Seq.h"
#include <vector>
#include <iostream>
using namespace std;

template <class T, bool Unique>
Seq<T, Unique>::Seq() {
    vector <T> seq;
    sequence = seq;
}

template<class T, bool Unique>
T Seq<T, Unique>::operator[](int i) {
    if (Unique) {
        const T &cref = sequence.at(i);
        return cref;
    } else {
        return sequence.at(i);
    }
}

template<class T, bool Unique>
void Seq<T, Unique>::addElem(T elem) {
    if (Unique) {
        if (checkUniq(elem)) sequence.push_back(elem);
        else cout << "Cannot add element " << elem << " in sequence " << typeid(this).name() << endl;
    } else sequence.push_back(elem);
}

template<class T, bool Unique>
bool Seq<T, Unique>::checkUniq(T elem) {
    bool res = true;
    for (int i = 0; i < sequence.size(); i++) {
        if (sequence.at(i) == elem) res = false;
    }
    return res;
}