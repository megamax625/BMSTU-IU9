#include <iostream>
#include "Seq.cpp"
using namespace std;

int main() {
    cout << "Testing non-unique sequence: " << endl;
    Seq<double, false> doubles;
    for (int i = 0.0; i < 100; i++) doubles.addElem(i * 1.2);
    cout << "Elem №3 value in doubles is: " << doubles[3] << "\n"
         << "Elem №30 value in doubles is: " << doubles[30] << endl;
    cout << "Testing unique sequence: " << endl;
    Seq<string, true> strings;
    strings.addElem("Sun");
    strings.addElem("Mercury");
    strings.addElem("Venus");
    strings.addElem("Earth");
    strings.addElem("Mars");
    strings.addElem("Snickers");
    strings.addElem("Bounty");
    strings.addElem("Twix");
    cout << "Third planet in solar system is " << strings[3] << endl;
    cout << "I like the taste of " << strings[7] << endl;
    string center = strings[0];
    cout << "Got a constant reference to the string of Sun: " << center << endl;
    center = "Black hole";
    cout << "First element of strings shouldn't be a Black hole: " << strings[0]
         << " ,but this should be: " << center << endl;
    strings.addElem("Sun");
}