call "C:\Perforce\WDK14393\BuildEnv\SetupBuildenv.cmd" x86_arm64
set _QCDK_ROOT_PATH=
set SKIP_PACKAGING_FOR_LOCAL_BUILDS=true
set DISABLE_PACK_BUILD=true
set DISABLE_AUTO_PACKAGING=true
set QCPlatform=8998

MSBuild "win_nwf_wdi.sln" /p:Configuration="Debug" /p:Platform=ARM64
