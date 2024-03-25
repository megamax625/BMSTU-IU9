#include "TriangleIterator.h"
#include <cmath>
#include "iterator"
#include <iostream>
using namespace std;
double** TriangleList::triangles = nullptr;
double TriangleList::Triangle::getArea() {
    return base * height / 2;
}
TriangleList::Triangle::Triangle(double base, double height) {
    this->base = base;
    this->height = height;
}
double TriangleList::Triangle::operator[](int j) {
    if (j == 0) return base;
    if (j == 1) return height;
    return 1.0;
}
TriangleList::TriangleList(int maxsize) {
    this->maxSize = maxsize;
    triangles = new double*[maxsize];
    for (int i = 0; i < maxsize; i++) {
        triangles[i] = new double[2];
        triangles[i][0] = 0.0;
        triangles[i][1] = 0.0;
    }
}
TriangleList::Triangle TriangleList::operator[](int i) {
    return Triangle(triangles[i][0], triangles[i][1]);
}
unsigned int TriangleList::getSize() {
    return size;
}
void TriangleList::addTriangle(TriangleList::Triangle *tr) {
    if (size > maxSize) throw "Array overflown";
    triangles[size][0] = tr->base;
    triangles[size][1] = tr->height;
    size++;
}
TriangleList::Triangle TriangleList::Triangle::stretch(double x) {
    double ratio = sqrt(x);
    base *= ratio;
    height *= ratio;
    return *this;
}
TriangleList::Triangle::Triangle() {
    this->base = 0.0;
    this->height = 0.0;
}
TriangleList::TriangleIterator TriangleList::begin() {
    return TriangleIterator(0, *new Triangle(this->triangles[0][0], this->triangles[0][1]));
}
TriangleList::TriangleIterator TriangleList::end() {
    return TriangleIterator(size - 1, *new Triangle(this->triangles[size-1][0], this->triangles[size-1][1]));
}
TriangleList::TriangleIterator::TriangleIterator(int i, Triangle tr) {
    this->i = i;
    this->tr = tr;
}
void TriangleList::TriangleIterator::change(const Triangle tr) {
    triangles[i][0] = tr.base;
    triangles[i][1] = tr.height;
}
TriangleList::TriangleIterator &TriangleList::TriangleIterator::operator++() {
    i++;
    TriangleIterator *newiter = new TriangleIterator(i, *new Triangle(triangles[i][0], triangles[i][1]));
    return *newiter;
}
TriangleList::Triangle TriangleList::TriangleIterator::operator*() {
    return tr;
}
bool TriangleList::TriangleIterator::operator==(TriangleList::TriangleIterator &iter) {
    return (this->i == iter.i);
}
bool TriangleList::TriangleIterator::operator!=(TriangleList::TriangleIterator &iter) {
    return !(*this == iter);
}

std::ostream& operator<< (std::ostream& os, TriangleList& trlist) {
    for (int i = 0; i < trlist.getSize(); i++) {
        os << "(" << trlist[i][0] << "," << trlist[i][1] << ")" << std::endl;
    }
    return os;
}