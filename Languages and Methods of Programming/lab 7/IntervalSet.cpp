#include "IntervalSet.h"

IntervalSet::IntervalSet(int maxSize) {
    this->maxSize = maxSize;
    set = new double*[maxSize];
    for (int i = 0; i < maxSize; i++) {
        set[i] = new double[2];
        set[i][0] = 0.0;
        set[i][1] = 0.0;
    }
}

IntervalSet::Interval::Interval(double left, double right) {
    this->left = left;
    this->right = right;
}

void IntervalSet::addInterval(IntervalSet::Interval *inter) {
    if (size > maxSize) throw "Array overflown";
    set[size][0] = inter->left;
    set[size][1] = inter->right;
    size++;
}

unsigned int IntervalSet::getSize() const  {
    return size;
}

IntervalSet::Interval IntervalSet::operator[](int i) {
    return Interval(set[i][0], set[i][1]);
}

double& IntervalSet::Interval::operator[](int j) {
    if (j == 0) return left;
    if (j == 1) return right;
}

bool IntervalSet::Interval::contains(double x) {
    return (left < x) && (x < right);
}

bool IntervalSet::containedInSet(double x) {
    bool cond = false;
    for (int i = 0; i < size; i++) {
        auto *inter = new Interval(set[i][0], set[i][1]);
        if (inter->contains(x)) cond = true;
        delete inter;
    }
    return cond;
}

void IntervalSet::shiftArrayLeft(int pos) { // чтобы удалить пару без создания вырожденных интервалов (0, 0)
    for (int i = pos; i < size; i++) {
        if ((set[i][0] == 0) && (set[i][1] == 0)) shiftArrayLeft(i);
        set[i][0] = set[i+1][0];
        set[i][1] = set[i+1][1]; // сдвигаем все элементы на 1 влево
    }
}

bool IntervalSet::Interval::isNestedIn(IntervalSet::Interval *inter) {
    return ((this->left >= inter->left) && (this->right < inter->right)) ||
    ((this->left > inter->left) && (this->right <= inter->right));
}

void IntervalSet::deleteNested() {
    int needShift = -1;
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            if (i != j) {
                auto *inter1 = new Interval(set[i][0], set[i][1]);
                auto *inter2 = new Interval(set[j][0], set[j][1]);
                if (inter1->isNestedIn(inter2)) {
                    size--;
                    inter1->left = 0;
                    inter1->right = 0;
                    if (needShift == -1) needShift = i;
                }
                delete inter1;
                delete inter2;
            }
        }
    }
    if (needShift != -1) shiftArrayLeft(needShift);
}

IntervalSet::IntervalSet(const IntervalSet &intervalSet) {
    this->maxSize = intervalSet.maxSize;
    this->size = intervalSet.getSize();
    set = new double*[maxSize];
    for (int i = 0; i < maxSize; i++) {
        set[i] = new double[2];
        std::copy(intervalSet.set[i], intervalSet.set[i] + 2, set[i]);
    }
}

IntervalSet::~IntervalSet() {
    for (int i = 0; i < maxSize; i++) {
        delete[] set[i];
    }
    delete set;
}

IntervalSet &IntervalSet::operator=(const IntervalSet &intervalSet) {
    if ((this != &intervalSet) && (maxSize == intervalSet.maxSize)) {
        for (int i = 0; i < maxSize; i++) {
            delete[] set[i];
        }
        delete[] set;
        set = new double*[maxSize];
        for (int i = 0; i < maxSize; i++) {
            set[i] = new double[2];
            std::copy(intervalSet.set[i], intervalSet.set[i] + 2, set[i]);
        }
    }
    return *this;
}

std::ostream& operator<< (std::ostream& os, IntervalSet& intervalSet) {
    for (int i = 0; i < intervalSet.getSize(); i++) {
        os << "(" << intervalSet[i][0] << "," << intervalSet[i][1] << ")" << std::endl;
    }
    return os;
}