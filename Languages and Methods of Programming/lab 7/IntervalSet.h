#ifndef INTERVALSET_H
#define INTERVALSET_H

#include <ostream>

class IntervalSet {
public:
    class Interval {
    public:
        double left, right;
        bool contains(double x);  // пункт 3
        bool isNestedIn(Interval *inter);
        Interval(double left, double right);
        double& operator[](int j);
    };
    unsigned int getSize() const; // пункт 1
    Interval operator[](int i); // пункт 2
    bool containedInSet(double x);
    void addInterval(Interval *inter); // пункт 4
    void shiftArrayLeft(int pos);
    void deleteNested(); // пункт 5
    IntervalSet(int maxSize);
    IntervalSet(const IntervalSet &intervalSet);
    virtual ~IntervalSet();
    IntervalSet& operator= (const IntervalSet &intervalSet);
    friend std::ostream& operator<< (std::ostream&, IntervalSet&);
private:
    unsigned int size = 0;
    double **set;
    int maxSize;
};

#endif