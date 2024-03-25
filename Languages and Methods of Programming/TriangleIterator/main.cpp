#include     <iostream>
#include "TriangleIterator.h"
using namespace std;
int main() {
    TriangleList *trl = new TriangleList(1000);
    for (int i = 1; i <= 3; i++) {
        TriangleList::Triangle *tr = new TriangleList::Triangle(3 * i, 4 * i);
        trl->addTriangle(tr);
    }
    TriangleList::Triangle *tr1 = new TriangleList::Triangle(10, 10);
    TriangleList::Triangle *tr2 = new TriangleList::Triangle(10, 20);
    trl->addTriangle(tr1); trl->addTriangle(tr2);
    cout << "Triangles list:\n" << *trl << endl;
    for (TriangleList::TriangleIterator iter = trl->begin(); iter != ++trl->end(); iter = ++iter) {
        TriangleList::Triangle tr = *iter;
        cout << "Area of triangle: " << tr.getArea() << ", Cathets: " << tr.base << " " << tr.height << endl;
        TriangleList::Triangle newtr = tr.stretch(4.0);
        iter.change(newtr);
    }
        cout << "\nMultiplied area by 4" << endl;
    for (TriangleList::TriangleIterator iter = trl->begin(); iter != ++trl->end(); iter = ++iter) {
        TriangleList::Triangle tr = *iter;
        cout << "Area of triangle: " << tr.getArea() << ", Cathets: " << tr.base << " " << tr.height << endl;
        TriangleList::Triangle newtr = tr.stretch(25);
        iter.change(newtr);
    }
        cout << "\nMultiplied area by 25" << endl;
    for (TriangleList::TriangleIterator iter = trl->begin(); iter != ++trl->end(); iter = ++iter) {
        TriangleList::Triangle tr = *iter;
        cout << "Area of triangle: " << tr.getArea() << ", Cathets: " << tr.base << " " << tr.height << endl;}
        cout << "\n" << endl;
    for (TriangleList::TriangleIterator iter = trl->begin(); iter != ++trl->end(); iter = ++iter) {
        TriangleList::Triangle tr = *iter;
        TriangleList::Triangle newtr = tr.stretch(0.01);
        iter.change(newtr);}
        cout << "\nMultiplied area by 0.01" << endl;
        cout << "Triangles list:\n" << *trl << endl;
}