#ifndef TRIANGLEITERATOR_TRIANGLEITERATOR_H
#define TRIANGLEITERATOR_TRIANGLEITERATOR_H
#include "iterator"
class TriangleList {
public:
    class Triangle {
    public:
        double base{}, height{};
        double getArea();
        Triangle(double base, double height);
        Triangle();
        double operator[](int j);
        Triangle stretch(double x);
    };
    class TriangleIterator : public std::iterator<std::forward_iterator_tag, Triangle> {
    public:
        Triangle tr;
        int i;
        TriangleIterator(int i, Triangle tr);
        void change(const Triangle tr);
        TriangleIterator& operator++();
        Triangle operator*();
        bool operator ==(TriangleIterator &iter);
        bool operator !=(TriangleIterator &iter);
    };
    TriangleIterator begin();
    TriangleIterator end();
    TriangleList(int maxsize);
    Triangle operator[](int i);
    unsigned int getSize();
    void addTriangle(Triangle *tr);
    friend std::ostream& operator<< (std::ostream&, TriangleList&);
private:
    unsigned int size = 0;
    static double **triangles;
    int maxSize;
};
#endif //TRIANGLEITERATOR_TRIANGLEITERATOR_H