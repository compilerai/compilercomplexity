GCC_REPO=https://github.com/gcc-mirror/gcc
LLVM_REPO=https://github.com/llvm-mirror/llvm

plot::
	git -C gcc checkout master
	perl plot.pl gcc
	git -C llvm checkout master
	perl plot.pl llvm

clone_repos::
	rm -rf gcc llvm
	git clone $(GCC_REPO)
	git clone $(LLVM_REPO)
