#include "IntervalSet.h"
#include <iostream>
using namespace std;

int main() {
    auto *interSet = new IntervalSet(1000);
    cout << "Number of intervals: " << interSet->getSize() << endl;
    auto *inter1 = new IntervalSet::Interval(1.5, 6.2);
    auto *inter2 = new IntervalSet::Interval(-2.4, 4.5);
    auto *inter3 = new IntervalSet::Interval(15.5, 60.2);
    auto *inter4 = new IntervalSet::Interval(10.5, 43.2);
    auto *inter5 = new IntervalSet::Interval(-14.5, 3.2);
    auto *inter6 = new IntervalSet::Interval(1.5, 2.3);
    auto *inter7 = new IntervalSet::Interval(0.0, 0.0);
    auto *inter8 = new IntervalSet::Interval(20.0, 60.2);
    interSet->addInterval(inter1);
    interSet->addInterval(inter2);
    interSet->addInterval(inter3);
    interSet->addInterval(inter4);
    interSet->addInterval(inter5);
    interSet->addInterval(inter6);
    interSet->addInterval(inter7);
    interSet->addInterval(inter8);
    cout << "Current set:" << "\n" << *interSet << endl;
    cout << "Number of intervals: " << interSet->getSize() << endl;
    IntervalSet &ref0 = interSet[0];
    IntervalSet &ref1 = interSet[1];
    cout << "Number 150.5 belongs to the set: " << interSet->containedInSet(150.5) << endl;
    cout << "Number -1 belongs to the set:" << interSet->containedInSet(-1) << endl;
    cout << "Number 30.1 belongs to the set: " << interSet->containedInSet(30.1) << endl;
    cout << "Removing all nested intervals..." << endl;
    interSet->deleteNested();
    cout << "Current set:" << "\n" << *interSet << endl;
    cout << "Number of intervals: " << interSet->getSize() << endl;
    delete inter1;
    delete inter2;
    delete inter3;
    delete inter4;
    delete inter5;
    delete inter6;
    auto *copySet = new IntervalSet(1000);
    copySet = interSet;
    cout << "Copied with = set:" << "\n" << *copySet << endl;
    cout << "Size of copied with = set: " << copySet->getSize() << endl;
    auto *copyConsSet = new IntervalSet(*interSet);
    cout << "Copied with copy constructor set:" << "\n" << *copyConsSet << endl;
    cout << "Size of copy constructor set: " << copyConsSet->getSize() << endl;
    delete interSet; // copyset также удаляется
    delete copyConsSet;
    return 0;
}