GCC_REPO=https://github.com/gcc-mirror/gcc
LLVM_REPO=https://github.com/llvm-mirror/llvm
EVERY_NTH_COMMIT=100

measure::
	rm -f commitcount
	perl plot.pl gcc commitcount $(EVERY_NTH_COMMIT)
	rm -f commitcount
	perl plot.pl llvm commitcount $(EVERY_NTH_COMMIT)
	rm -f commitcount

plot::
	rm -f commitcount
	git -C gcc rebase --exec "cd ../ && perl plot.pl gcc commitcount $(EVERY_NTH_COMMIT) && cd gcc" 3cf0d8938a953e && cd ..
	rm -f commitcount
	git -C llvm rebase --exec "cd ../ && perl plot.pl llvm commitcount $(EVERY_NTH_COMMIT) && cd llvm" 8d0afd3d32d1d && cd ..
	rm -f commitcount

clone_repos::
	rm -rf gcc llvm
	git clone $(GCC_REPO)
	git clone $(LLVM_REPO)
