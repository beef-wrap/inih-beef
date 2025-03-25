cmake -S . -B inih/build -DCMAKE_BUILD_TYPE=Debug
cmake --build inih/build --config Debug

cmake -S . -B inih/build -DCMAKE_BUILD_TYPE=Release
cmake --build inih/build --config Release