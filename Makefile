all: helloc hellocpp hellocppstatic hellocppfullstatic multi_helloc multi_hellocpp multi_hellocppstatic multi_hellocppfullstatic
	hyperfine -N --runs 5000 ./helloc
	hyperfine -N --runs 5000 ./hellocpp
	hyperfine -N --runs 5000 ./hellocppstatic
	hyperfine -N --runs 5000 ./hellocppfullstatic
	hyperfine -N --runs 5000 ./multi_helloc
	hyperfine -N --runs 5000 ./multi_hellocpp
	hyperfine -N --runs 5000 ./multi_hellocppstatic
	hyperfine -N --runs 5000 ./multi_hellocppfullstatic

helloc: hello.c
	cc -O2 -o helloc hello.c -Wall

hellocpp: hello.cpp
	c++ -O2 -o hellocpp hello.cpp -Wall

hellocppstatic: hello.cpp
	c++ -O2 -o hellocppstatic hello.cpp -Wall -static-libstdc++

hellocppfullstatic: hello.cpp
	c++ -O2 -o hellocppfullstatic hello.cpp -Wall -static-libstdc++ -static-libgcc

multi_helloc: multi_hello.c
	cc -O2 -o multi_helloc multi_hello.c -Wall

multi_hellocpp: multi_hello.cpp
	c++ -O2 -o multi_hellocpp multi_hello.cpp -Wall

multi_hellocppstatic: multi_hello.cpp
	c++ -O2 -o multi_hellocppstatic multi_hello.cpp -Wall -static-libstdc++

multi_hellocppfullstatic: multi_hello.cpp
	c++ -O2 -o multi_hellocppfullstatic multi_hello.cpp -Wall -static-libstdc++ -static-libgcc

clean:
	rm -f hellocpp helloc hellocppstatic hellocppfullstatic multi_hellocpp multi_helloc multi_hellocppstatic multi_hellocppfullstatic
