#include <iostream>
#include <string>

using namespace std;
extern "C" int _length(char[]);

int main() {
	string s1 = "Cat in the hat.";
	char s2[] = "Cat in the hat.";

	char* pointer = s2;

	cout << s1 <<  " C++ length= " << s1.length() << endl;
	cout << s2 <<  " ASM length= " << _length(pointer) << endl;
	
    	return 0;
}