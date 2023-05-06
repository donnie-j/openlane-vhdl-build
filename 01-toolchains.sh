echo patch for musl 1.2.4

patch -p1 << 'EOF'
diff --git a/Makefile b/Makefile
index 09f8c2d..5d3d805 100644
--- a/Makefile
+++ b/Makefile
@@ -4,7 +4,7 @@ SOURCES = sources
 CONFIG_SUB_REV = 3d5db9ebe860
 BINUTILS_VER = 2.33.1
 GCC_VER = 9.4.0
-MUSL_VER = 1.2.3
+MUSL_VER = 1.2.4
 GMP_VER = 6.1.2
 MPC_VER = 1.1.0
 MPFR_VER = 4.0.2
diff --git a/hashes/musl-1.2.4.tar.gz.sha1 b/hashes/musl-1.2.4.tar.gz.sha1
new file mode 100644
index 0000000..0f94407
--- /dev/null
+++ b/hashes/musl-1.2.4.tar.gz.sha1
@@ -0,0 +1 @@
+78eb982244b857dbacb2ead25cc0f631ce44204d  musl-1.2.4.tar.gz
EOF


echo patch for vfork 

mkdir patches/musl-1.2.4 && cat >> patches/musl-1.2.4/0001-nommu.patch << 'EOF'

echo install mercurial
wget https://www.mercurial-scm.org/release/mercurial-6.4.2.tar.gz
tar -zxvf mercurial-6.4.2.tar.gz
cd mercurial-6.4.2

make install

cd ..