#ifndef SEQ_SEQ_H
#define SEQ_SEQ_H

#include <vector>

template <class T, bool Unique>
class Seq {
public:
    Seq();
    T operator[](int i);
    void addElem(T elem);
private:
    std::vector<T> sequence;
    bool checkUniq(T elem);
};

#endif