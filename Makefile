GCC_REPO=https://github.com/gcc-mirror/gcc
LLVM_REPO=https://github.com/llvm-mirror/llvm

measure::
	perl plot.pl gcc
	perl plot.pl llvm

plot::
	git -C gcc rebase --exec "cd ../ && perl plot.pl gcc && cd gcc" 3cf0d8938a953e && cd ..
	git -C llvm rebase --exec "cd ../ && perl plot.pl llvm && cd llvm" 8d0afd3d32d1d && cd ..

clone_repos::
	rm -rf gcc llvm
	git clone $(GCC_REPO)
	git clone $(LLVM_REPO)
