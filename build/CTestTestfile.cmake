# CMake generated Testfile for 
# Source directory: /home/dvanderson/code/libxml2
# Build directory: /home/dvanderson/code/libxml2/build
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(runtest "/home/dvanderson/code/libxml2/build/runtest" "--out" "/home/dvanderson/code/libxml2/build")
set_tests_properties(runtest PROPERTIES  WORKING_DIRECTORY "/home/dvanderson/code/libxml2" _BACKTRACE_TRIPLES "/home/dvanderson/code/libxml2/CMakeLists.txt;502;add_test;/home/dvanderson/code/libxml2/CMakeLists.txt;0;")
add_test(runsuite "/home/dvanderson/code/libxml2/build/runsuite")
set_tests_properties(runsuite PROPERTIES  WORKING_DIRECTORY "/home/dvanderson/code/libxml2" _BACKTRACE_TRIPLES "/home/dvanderson/code/libxml2/CMakeLists.txt;503;add_test;/home/dvanderson/code/libxml2/CMakeLists.txt;0;")
add_test(testapi "/home/dvanderson/code/libxml2/build/testapi")
set_tests_properties(testapi PROPERTIES  _BACKTRACE_TRIPLES "/home/dvanderson/code/libxml2/CMakeLists.txt;508;add_test;/home/dvanderson/code/libxml2/CMakeLists.txt;0;")
add_test(testchar "/home/dvanderson/code/libxml2/build/testchar")
set_tests_properties(testchar PROPERTIES  _BACKTRACE_TRIPLES "/home/dvanderson/code/libxml2/CMakeLists.txt;510;add_test;/home/dvanderson/code/libxml2/CMakeLists.txt;0;")
add_test(testdict "/home/dvanderson/code/libxml2/build/testdict")
set_tests_properties(testdict PROPERTIES  _BACKTRACE_TRIPLES "/home/dvanderson/code/libxml2/CMakeLists.txt;511;add_test;/home/dvanderson/code/libxml2/CMakeLists.txt;0;")
add_test(testrecurse "/home/dvanderson/code/libxml2/build/testrecurse")
set_tests_properties(testrecurse PROPERTIES  WORKING_DIRECTORY "/home/dvanderson/code/libxml2" _BACKTRACE_TRIPLES "/home/dvanderson/code/libxml2/CMakeLists.txt;512;add_test;/home/dvanderson/code/libxml2/CMakeLists.txt;0;")
add_test(testThreads "/home/dvanderson/code/libxml2/build/testThreads")
set_tests_properties(testThreads PROPERTIES  WORKING_DIRECTORY "/home/dvanderson/code/libxml2" _BACKTRACE_TRIPLES "/home/dvanderson/code/libxml2/CMakeLists.txt;513;add_test;/home/dvanderson/code/libxml2/CMakeLists.txt;0;")
