#!/bin/bash
set -euo pipefail

# Define variables
CLANG_PRIORITY="${CLANG_PRIORITY:-$CLANG_VERSION}"
LLVM_LIB32_PATH="/usr/lib/llvm-$CLANG_VERSION/lib32"
I386_LINUX_GNU_PATH="/usr/lib/i386-linux-gnu"
INITIAL_DIR="$(pwd)"

# Install Clang
apt-get install -y \
    clang-"$CLANG_VERSION" \
    clang-format-"$CLANG_VERSION" \
    clang-tidy-"$CLANG_VERSION" \
    clang-tools-"$CLANG_VERSION" \
    clangd-"$CLANG_VERSION" \
    libc++-"$CLANG_VERSION"-dev \
    libc++abi-"$CLANG_VERSION"-dev \
    libclang-"$CLANG_VERSION"-dev \
    libpolly-"$CLANG_VERSION"-dev \
    libunwind-"$CLANG_VERSION"-dev \
    lld-"$CLANG_VERSION"

# Configure alternatives
update-alternatives \
    --install /usr/bin/clang clang /usr/bin/clang-"$CLANG_VERSION" "$CLANG_PRIORITY" \
    --slave /usr/bin/clang++ clang++ /usr/bin/clang++-"$CLANG_VERSION" \
    --slave /usr/bin/clang-apply-replacements clang-apply-replacements /usr/bin/clang-apply-replacements-"$CLANG_VERSION" \
    --slave /usr/bin/clang-change-namespace clang-change-namespace /usr/bin/clang-change-namespace-"$CLANG_VERSION" \
    --slave /usr/bin/clang-check clang-check /usr/bin/clang-check-"$CLANG_VERSION" \
    --slave /usr/bin/clang-cl clang-cl /usr/bin/clang-cl-"$CLANG_VERSION" \
    --slave /usr/bin/clang-cpp clang-cpp /usr/bin/clang-cpp-"$CLANG_VERSION" \
    --slave /usr/bin/clang-doc clang-doc /usr/bin/clang-doc-"$CLANG_VERSION" \
    --slave /usr/bin/clang-extdef-mapping clang-extdef-mapping /usr/bin/clang-extdef-mapping-"$CLANG_VERSION" \
    --slave /usr/bin/clang-format clang-format /usr/bin/clang-format-"$CLANG_VERSION" \
    --slave /usr/bin/clang-format-diff clang-format-diff /usr/bin/clang-format-diff-"$CLANG_VERSION" \
    --slave /usr/bin/clang-include-cleaner clang-include-cleaner /usr/bin/clang-include-cleaner-"$CLANG_VERSION" \
    --slave /usr/bin/clang-include-fixer clang-include-fixer /usr/bin/clang-include-fixer-"$CLANG_VERSION" \
    --slave /usr/bin/clang-linker-wrapper clang-linker-wrapper /usr/bin/clang-linker-wrapper-"$CLANG_VERSION" \
    --slave /usr/bin/clang-move clang-move /usr/bin/clang-move-"$CLANG_VERSION" \
    --slave /usr/bin/clang-offload-bundler clang-offload-bundler /usr/bin/clang-offload-bundler-"$CLANG_VERSION" \
    --slave /usr/bin/clang-offload-packager clang-offload-packager /usr/bin/clang-offload-packager-"$CLANG_VERSION" \
    --slave /usr/bin/clang-pseudo clang-pseudo /usr/bin/clang-pseudo-"$CLANG_VERSION" \
    --slave /usr/bin/clang-query clang-query /usr/bin/clang-query-"$CLANG_VERSION" \
    --slave /usr/bin/clang-refactor clang-refactor /usr/bin/clang-refactor-"$CLANG_VERSION" \
    --slave /usr/bin/clang-rename clang-rename /usr/bin/clang-rename-"$CLANG_VERSION" \
    --slave /usr/bin/clang-reorder-fields clang-reorder-fields /usr/bin/clang-reorder-fields-"$CLANG_VERSION" \
    --slave /usr/bin/clang-repl clang-repl /usr/bin/clang-repl-"$CLANG_VERSION" \
    --slave /usr/bin/clang-scan-deps clang-scan-deps /usr/bin/clang-scan-deps-"$CLANG_VERSION" \
    --slave /usr/bin/clang-tblgen clang-tblgen /usr/bin/clang-tblgen-"$CLANG_VERSION" \
    --slave /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-"$CLANG_VERSION" \
    --slave /usr/bin/clang-tidy-diff clang-tidy-diff /usr/bin/clang-tidy-diff-"$CLANG_VERSION".py \
    --slave /usr/bin/llvm-ar llvm-ar /usr/bin/llvm-ar-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-as llvm-as /usr/bin/llvm-as-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-addr2line llvm-addr2line /usr/bin/llvm-addr2line-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-bcanalyzer llvm-bcanalyzer /usr/bin/llvm-bcanalyzer-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-bitcode-strip llvm-bitcode-strip /usr/bin/llvm-bitcode-strip-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-c-test llvm-c-test /usr/bin/llvm-c-test-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-cat llvm-cat /usr/bin/llvm-cat-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-cfi-verify llvm-cfi-verify /usr/bin/llvm-cfi-verify-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-cov llvm-cov /usr/bin/llvm-cov-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-cvtres llvm-cvtres /usr/bin/llvm-cvtres-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-cxxdump llvm-cxxdump /usr/bin/llvm-cxxdump-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-cxxfilt llvm-cxxfilt /usr/bin/llvm-cxxfilt-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-cxxmap llvm-cxxmap /usr/bin/llvm-cxxmap-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-debuginfo-analyzer llvm-debuginfo-analyzer /usr/bin/llvm-debuginfo-analyzer-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-debuginfod llvm-debuginfod /usr/bin/llvm-debuginfod-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-debuginfod-find llvm-debuginfod-find /usr/bin/llvm-debuginfod-find-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-diff llvm-diff /usr/bin/llvm-diff-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-dis llvm-dis /usr/bin/llvm-dis-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-dlltool llvm-dlltool /usr/bin/llvm-dlltool-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-dwarfdump llvm-dwarfdump /usr/bin/llvm-dwarfdump-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-dwarfutil llvm-dwarfutil /usr/bin/llvm-dwarfutil-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-dwp llvm-dwp /usr/bin/llvm-dwp-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-exegesis llvm-exegesis /usr/bin/llvm-exegesis-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-extract llvm-extract /usr/bin/llvm-extract-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-gsymutil llvm-gsymutil /usr/bin/llvm-gsymutil-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-ifs llvm-ifs /usr/bin/llvm-ifs-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-install-name-tool llvm-install-name-tool /usr/bin/llvm-install-name-tool-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-jitlink llvm-jitlink /usr/bin/llvm-jitlink-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-jitlink-executor llvm-jitlink-executor /usr/bin/llvm-jitlink-executor-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-lib llvm-lib /usr/bin/llvm-lib-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-libtool-darwin llvm-libtool-darwin /usr/bin/llvm-libtool-darwin-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-link llvm-link /usr/bin/llvm-link-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-lipo llvm-lipo /usr/bin/llvm-lipo-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-lto llvm-lto /usr/bin/llvm-lto-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-lto2 llvm-lto2 /usr/bin/llvm-lto2-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-mc llvm-mc /usr/bin/llvm-mc-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-mca llvm-mca /usr/bin/llvm-mca-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-ml llvm-ml /usr/bin/llvm-ml-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-modextract llvm-modextract /usr/bin/llvm-modextract-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-mt llvm-mt /usr/bin/llvm-mt-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-nm llvm-nm /usr/bin/llvm-nm-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-objcopy llvm-objcopy /usr/bin/llvm-objcopy-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-objdump llvm-objdump /usr/bin/llvm-objdump-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-opt-report llvm-opt-report /usr/bin/llvm-opt-report-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-otool llvm-otool /usr/bin/llvm-otool-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-pdbutil llvm-pdbutil /usr/bin/llvm-pdbutil-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-PerfectShuffle llvm-PerfectShuffle /usr/bin/llvm-PerfectShuffle-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-profdata llvm-profdata /usr/bin/llvm-profdata-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-profgen llvm-profgen /usr/bin/llvm-profgen-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-ranlib llvm-ranlib /usr/bin/llvm-ranlib-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-rc llvm-rc /usr/bin/llvm-rc-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-readelf llvm-readelf /usr/bin/llvm-readelf-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-readobj llvm-readobj /usr/bin/llvm-readobj-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-readtapi llvm-readtapi /usr/bin/llvm-readtapi-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-reduce llvm-reduce /usr/bin/llvm-reduce-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-remarkutil llvm-remarkutil /usr/bin/llvm-remarkutil-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-rtdyld llvm-rtdyld /usr/bin/llvm-rtdyld-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-sim llvm-sim /usr/bin/llvm-sim-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-size llvm-size /usr/bin/llvm-size-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-split llvm-split /usr/bin/llvm-split-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-stress llvm-stress /usr/bin/llvm-stress-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-strings llvm-strings /usr/bin/llvm-strings-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-strip llvm-strip /usr/bin/llvm-strip-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-symbolizer llvm-symbolizer /usr/bin/llvm-symbolizer-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-tblgen llvm-tblgen /usr/bin/llvm-tblgen-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-tli-checker llvm-tli-checker /usr/bin/llvm-tli-checker-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-undname llvm-undname /usr/bin/llvm-undname-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-windres llvm-windres /usr/bin/llvm-windres-"$CLANG_VERSION" \
    --slave /usr/bin/llvm-xray llvm-xray /usr/bin/llvm-xray-"$CLANG_VERSION" \
    --slave /usr/bin/amdgpu-arch amdgpu-arch /usr/bin/amdgpu-arch-"$CLANG_VERSION" \
    --slave /usr/bin/analyze-build analyze-build /usr/bin/analyze-build-"$CLANG_VERSION" \
    --slave /usr/bin/asan_symbolize asan_symbolize /usr/bin/asan_symbolize-"$CLANG_VERSION" \
    --slave /usr/bin/bugpoint bugpoint /usr/bin/bugpoint-"$CLANG_VERSION" \
    --slave /usr/bin/c-index-test c-index-test /usr/bin/c-index-test-"$CLANG_VERSION" \
    --slave /usr/bin/clangd clangd /usr/bin/clangd-"$CLANG_VERSION" \
    --slave /usr/bin/count count /usr/bin/count-"$CLANG_VERSION" \
    --slave /usr/bin/diagtool diagtool /usr/bin/diagtool-"$CLANG_VERSION" \
    --slave /usr/bin/dsymutil dsymutil /usr/bin/dsymutil-"$CLANG_VERSION" \
    --slave /usr/bin/FileCheck FileCheck /usr/bin/FileCheck-"$CLANG_VERSION" \
    --slave /usr/bin/find-all-symbols find-all-symbols /usr/bin/find-all-symbols-"$CLANG_VERSION" \
    --slave /usr/bin/git-clang-format git-clang-format /usr/bin/git-clang-format-"$CLANG_VERSION" \
    --slave /usr/bin/hmaptool hmaptool /usr/bin/hmaptool-"$CLANG_VERSION" \
    --slave /usr/bin/hwasan_symbolize hwasan_symbolize /usr/bin/hwasan_symbolize-"$CLANG_VERSION" \
    --slave /usr/bin/intercept-build intercept-build /usr/bin/intercept-build-"$CLANG_VERSION" \
    --slave /usr/bin/llc llc /usr/bin/llc-"$CLANG_VERSION" \
    --slave /usr/bin/lld lld /usr/bin/lld-"$CLANG_VERSION" \
    --slave /usr/bin/lld-link lld-link /usr/bin/lld-link-"$CLANG_VERSION" \
    --slave /usr/bin/lli lli /usr/bin/lli-"$CLANG_VERSION" \
    --slave /usr/bin/lli-child-target lli-child-target /usr/bin/lli-child-target-"$CLANG_VERSION" \
    --slave /usr/bin/modularize modularize /usr/bin/modularize-"$CLANG_VERSION" \
    --slave /usr/bin/not not /usr/bin/not-"$CLANG_VERSION" \
    --slave /usr/bin/nvptx-arch nvptx-arch /usr/bin/nvptx-arch-"$CLANG_VERSION" \
    --slave /usr/bin/obj2yaml obj2yaml /usr/bin/obj2yaml-"$CLANG_VERSION" \
    --slave /usr/bin/opt opt /usr/bin/opt-"$CLANG_VERSION" \
    --slave /usr/bin/pp-trace pp-trace /usr/bin/pp-trace-"$CLANG_VERSION" \
    --slave /usr/bin/run-clang-tidy run-clang-tidy /usr/bin/run-clang-tidy-"$CLANG_VERSION" \
    --slave /usr/bin/sancov sancov /usr/bin/sancov-"$CLANG_VERSION" \
    --slave /usr/bin/sanstats sanstats /usr/bin/sanstats-"$CLANG_VERSION" \
    --slave /usr/bin/scan-build scan-build /usr/bin/scan-build-"$CLANG_VERSION" \
    --slave /usr/bin/scan-build-py scan-build-py /usr/bin/scan-build-py-"$CLANG_VERSION" \
    --slave /usr/bin/scan-view scan-view /usr/bin/scan-view-"$CLANG_VERSION" \
    --slave /usr/bin/split-file split-file /usr/bin/split-file-"$CLANG_VERSION" \
    --slave /usr/bin/UnicodeNameMappingGenerator UnicodeNameMappingGenerator /usr/bin/UnicodeNameMappingGenerator-"$CLANG_VERSION" \
    --slave /usr/bin/verify-uselistorder verify-uselistorder /usr/bin/verify-uselistorder-"$CLANG_VERSION" \
    --slave /usr/bin/wasm-ld wasm-ld /usr/bin/wasm-ld-"$CLANG_VERSION" \
    --slave /usr/bin/yaml-bench yaml-bench /usr/bin/yaml-bench-"$CLANG_VERSION" \
    --slave /usr/bin/yaml2obj yaml2obj /usr/bin/yaml2obj-"$CLANG_VERSION"

# Create directory for LLVM 32-bit libraries
mkdir -p "$LLVM_LIB32_PATH"

# Override APT sandbox user to root (temporary fix for container environment)
echo 'APT::Sandbox::User "root";' > /etc/apt/apt.conf.d/10sandbox

# Install libc++ for i386 architecture
TEMP_DIR="$(mktemp -d)"
cd "$TEMP_DIR"
apt-get download libc++1-"$CLANG_VERSION":i386
dpkg -x ./*.deb .
cp ./usr/lib/llvm-"$CLANG_VERSION"/lib/libc++.so.1.0 "$LLVM_LIB32_PATH"
cd "$LLVM_LIB32_PATH"
ln -s libc++.so.1.0 libc++.so.1
cp -P libc++.so.1 "$I386_LINUX_GNU_PATH"
cd "$I386_LINUX_GNU_PATH"
ln -s ../llvm-"$CLANG_VERSION"/lib32/libc++.so.1.0 libc++.so.1.0
cd "$INITIAL_DIR"
rm -rf "$TEMP_DIR"

# Install libc++-dev for i386 architecture
TEMP_DIR="$(mktemp -d)"
cd "$TEMP_DIR"
apt-get download libc++-"$CLANG_VERSION"-dev:i386
dpkg -x ./*.deb .
cp ./usr/lib/llvm-"$CLANG_VERSION"/lib/* "$LLVM_LIB32_PATH"
cd "$I386_LINUX_GNU_PATH"
ln -s ../llvm-"$CLANG_VERSION"/lib32/libc++.a libc++.a
ln -s ../llvm-"$CLANG_VERSION"/lib32/libc++.so libc++.so
ln -s ../llvm-"$CLANG_VERSION"/lib32/libc++experimental.a libc++experimental.a
cd "$INITIAL_DIR"
rm -rf "$TEMP_DIR"

# Install libc++abi for i386 architecture
TEMP_DIR="$(mktemp -d)"
cd "$TEMP_DIR"
apt-get download libc++abi1-"$CLANG_VERSION":i386
dpkg -x ./*.deb .
cp ./usr/lib/llvm-"$CLANG_VERSION"/lib/libc++abi.so.1.0 "$LLVM_LIB32_PATH"
cd "$LLVM_LIB32_PATH"
ln -s libc++abi.so.1.0 libc++abi.so.1
cp -P libc++abi.so.1 "$I386_LINUX_GNU_PATH"
cd "$I386_LINUX_GNU_PATH"
ln -s ../llvm-"$CLANG_VERSION"/lib32/libc++abi.so.1.0 libc++abi.so.1.0
cd "$INITIAL_DIR"
rm -rf "$TEMP_DIR"

# Install libc++abi-dev for i386 architecture
TEMP_DIR="$(mktemp -d)"
cd "$TEMP_DIR"
apt-get download libc++abi-"$CLANG_VERSION"-dev:i386
dpkg -x ./*.deb .
cp ./usr/lib/llvm-"$CLANG_VERSION"/lib/libc++abi.a "$LLVM_LIB32_PATH"
cd "$LLVM_LIB32_PATH"
ln -s libc++abi.so.1 libc++abi.so
cd "$I386_LINUX_GNU_PATH"
ln -s ../llvm-"$CLANG_VERSION"/lib32/libc++abi.so libc++abi.so
ln -s ../llvm-"$CLANG_VERSION"/lib32/libc++abi.a libc++abi.a
cd "$INITIAL_DIR"
rm -rf "$TEMP_DIR"

# Install libunwind for i386 architecture
TEMP_DIR="$(mktemp -d)"
cd "$TEMP_DIR"
apt-get download libunwind-"$CLANG_VERSION":i386
dpkg -x ./*.deb .
cp ./usr/lib/llvm-"$CLANG_VERSION"/lib/libunwind.so.1.0 "$LLVM_LIB32_PATH"
cd "$LLVM_LIB32_PATH"
ln -s libunwind.so.1.0 libunwind.so.1
cp -P libunwind.so.1 "$I386_LINUX_GNU_PATH"
cd "$I386_LINUX_GNU_PATH"
ln -s ../llvm-"$CLANG_VERSION"/lib32/libunwind.so.1.0 libunwind.so.1.0
cd "$INITIAL_DIR"
rm -rf "$TEMP_DIR"

# Install libunwind-dev for i386 architecture
TEMP_DIR="$(mktemp -d)"
cd "$TEMP_DIR"
apt-get download libunwind-"$CLANG_VERSION"-dev:i386
dpkg -x ./*.deb .
cp ./usr/lib/llvm-"$CLANG_VERSION"/lib/libunwind.a "$LLVM_LIB32_PATH"
cd "$LLVM_LIB32_PATH"
ln -s libunwind.so.1 libunwind.so
cd "$I386_LINUX_GNU_PATH"
ln -s ../llvm-"$CLANG_VERSION"/lib32/libunwind.so libunwind.so
ln -s ../llvm-"$CLANG_VERSION"/lib32/libunwind.a libunwind.a
cd "$INITIAL_DIR"
rm -rf "$TEMP_DIR"

# Remove temporary APT sandbox override
rm -f /etc/apt/apt.conf.d/10sandbox

# Print success message
echo ""
echo "Clang version $CLANG_VERSION installation completed successfully."
echo ""
