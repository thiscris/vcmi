cd $APPVEYOR_BUILD_FOLDER
git submodule update --init --recursive

cd ..

curl -LfsS -o "vcpkg-export-${VCMI_BUILD_PLATFORM}-windows-v140.7z" \
	"https://github.com/nullkiller/vcmi-deps-windows/releases/download/v1.3/vcpkg-export-${VCMI_BUILD_PLATFORM}-windows-v140.7z"
7z x "vcpkg-export-${VCMI_BUILD_PLATFORM}-windows-v140.7z"

rmdir vcpkg\installed\${VCMI_BUILD_PLATFORM}-windows\debug /S/Q
xcopy vcpkg\installed\${VCMI_BUILD_PLATFORM}-windows\bin vcpkg\installed\${VCMI_BUILD_PLATFORM}-windows\debug\bin /S/I/Q

cd $APPVEYOR_BUILD_FOLDER
mkdir build_$VCMI_BUILD_PLATFORM
cd build_$VCMI_BUILD_PLATFORM

source $APPVEYOR_BUILD_FOLDER/CI/get_package_name.sh
cmake -G "$VCMI_GENERATOR" .. -DCMAKE_TOOLCHAIN_FILE=$APPVEYOR_BUILD_FOLDER/../vcpkg/scripts/buildsystems/vcpkg.cmake \
	-DPACKAGE_NAME_SUFFIX:STRING="$VCMI_PACKAGE_NAME_SUFFIX" \
	-DPACKAGE_FILE_NAME:STRING="$VCMI_PACKAGE_FILE_NAME"
