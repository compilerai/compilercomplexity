GCC_REPO=https://github.com/gcc-mirror/gcc
LLVM_REPO=https://github.com/llvm/llvm-project

plot::
	git -C gcc checkout master
	perl plot.pl gcc
	git -C llvm-project checkout -f main
	perl plot.pl llvm-project

clone_repos::
	rm -rf gcc llvm-project
	git clone $(GCC_REPO)
	git clone $(LLVM_REPO)
