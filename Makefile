GCC_REPO=https://github.com/gcc-mirror/gcc
LLVM_REPO=https://github.com/llvm-mirror/llvm

plot::
	perl plot.pl gcc
	perl plot.pl llvm

clone_repos::
	rm -rf gcc llvm
	git clone $(GCC_REPO)
	git clone $(LLVM_REPO)

